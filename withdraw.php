<?php
session_start();
require_once 'db.php';

if (!isset($_SESSION['wallet_address'])) {
    header("Location: index.php");
    exit;
}

// Obtener la clave de API de FaucetPay desde la base de datos
$apiQuery = $conn->prepare("SELECT api_value FROM settings_api WHERE api_key = 'faucetpay_api_key'");
$apiQuery->execute();
$apiResult = $apiQuery->get_result();
$apiData = $apiResult->fetch_assoc();
$apiKey = $apiData['api_value'];

// Obtener la información del usuario
$userQuery = $conn->prepare("SELECT id, wallet_address, balance FROM Users WHERE wallet_address = ?");
$userQuery->bind_param("s", $_SESSION['wallet_address']);
$userQuery->execute();
$userResult = $userQuery->get_result();
$userData = $userResult->fetch_assoc();

// Obtener configuraciones de retiro
$minWithdrawQuery = $conn->prepare("SELECT setting_value FROM settings_withdraw WHERE setting_key = 'min_withdraw_amount'");
$minWithdrawQuery->execute();
$minWithdrawResult = $minWithdrawQuery->get_result();
$minWithdrawData = $minWithdrawResult->fetch_assoc();
$minWithdrawAmount = $minWithdrawData['setting_value'];

$maxWithdrawalsQuery = $conn->prepare("SELECT setting_value FROM settings_withdraw WHERE setting_key = 'max_withdrawals_per_day'");
$maxWithdrawalsQuery->execute();
$maxWithdrawalsResult = $maxWithdrawalsQuery->get_result();
$maxWithdrawalsData = $maxWithdrawalsResult->fetch_assoc();
$maxWithdrawalsPerDay = $maxWithdrawalsData['setting_value'];

if (isset($_POST['withdraw'])) {
    // Obtener los datos del formulario
    $toAddress = $_POST['address'];
    $amount = $_POST['amount'];
    $currency = 'USDT';

    // Verificar si la cantidad es mayor o igual al mínimo de retiro
    if ($amount < $minWithdrawAmount) {
        $error = 'Withdrawal amount must be at least ' . $minWithdrawAmount . ' USDT.';
    } elseif ($amount > $userData['balance']) {
        $error = 'Withdrawal amount exceeds your current balance.';
    } else {
        // Verificar si el usuario ha excedido el límite de retiros diarios
        $today = date('Y-m-d');
        $withdrawLimitQuery = $conn->prepare("SELECT withdrawal_count FROM withdrawal_limits WHERE user_id = ? AND withdrawal_date = ?");
        $withdrawLimitQuery->bind_param("is", $userData['id'], $today);
        $withdrawLimitQuery->execute();
        $withdrawLimitResult = $withdrawLimitQuery->get_result();
        $withdrawLimitData = $withdrawLimitResult->fetch_assoc();
        $withdrawalCount = $withdrawLimitData['withdrawal_count'] ?? 0;

        if ($withdrawalCount >= $maxWithdrawalsPerDay) {
            $error = 'You have reached the maximum number of withdrawals for today.';
        } else {
            // Convertir la cantidad a la unidad más pequeña según la moneda
            $amountInSmallestUnit = bcmul($amount, '100000000', 0); // 1 USDT = 1,000,000 "microdollars"

            // Endpoint de la API
            $apiUrl = 'https://faucetpay.io/api/v1/send';

            // Datos a enviar a la API
            $postData = [
                'api_key' => $apiKey,
                'to' => $toAddress,
                'amount' => $amountInSmallestUnit,
                'currency' => $currency,
            ];

            // Configuración de la solicitud cURL
            $ch = curl_init($apiUrl);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);

            // Ejecutar la solicitud y obtener la respuesta
            $response = curl_exec($ch);

            // Manejo de errores cURL
            if(curl_errno($ch)) {
                $error = 'cURL Error: ' . curl_error($ch);
            } else {
                // Decodificar la respuesta JSON
                $responseData = json_decode($response, true);

                // Verificar la respuesta
                if ($responseData['status'] == 200) {
                    $success = 'Withdrawal successful: ' . $responseData['message'];

                    // Registrar el retiro en el historial
                    $insertHistoryQuery = $conn->prepare("INSERT INTO withdrawal_history (user_id, amount) VALUES (?, ?)");
                    $insertHistoryQuery->bind_param("id", $userData['id'], $amount);
                    $insertHistoryQuery->execute();

                    // Actualizar el balance del usuario
                    $newBalance = $userData['balance'] - $amount;
                    $updateBalanceQuery = $conn->prepare("UPDATE Users SET balance = ? WHERE id = ?");
                    $updateBalanceQuery->bind_param("di", $newBalance, $userData['id']);
                    $updateBalanceQuery->execute();

                    // Actualizar el conteo de retiros del usuario para el día actual
                    if ($withdrawLimitData) {
                        $updateWithdrawCountQuery = $conn->prepare("UPDATE withdrawal_limits SET withdrawal_count = withdrawal_count + 1 WHERE user_id = ? AND withdrawal_date = ?");
                        $updateWithdrawCountQuery->bind_param("is", $userData['id'], $today);
                        $updateWithdrawCountQuery->execute();
                    } else {
                        $insertWithdrawCountQuery = $conn->prepare("INSERT INTO withdrawal_limits (user_id, withdrawal_date, withdrawal_count) VALUES (?, ?, 1)");
                        $insertWithdrawCountQuery->bind_param("is", $userData['id'], $today);
                        $insertWithdrawCountQuery->execute();
                    }
                } else {
                    $error = 'Withdrawal error: ' . $responseData['message'];
                }
            }

            curl_close($ch);
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Withdraw with FaucetPay.io</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container-withdraw-unique">
        <div class="balance-box-unique">
            <h2 style="color: black;">Your Balance</h2>

            <p><?php echo number_format($userData['balance'], 6); ?> USDT</p>
        </div>
        <?php if (isset($error)): ?>
            <div class="error-unique"><?php echo htmlspecialchars($error); ?></div>
        <?php endif; ?>
        <?php if (isset($success)): ?>
            <div class="success-unique"><?php echo htmlspecialchars($success); ?></div>
        <?php endif; ?>
        <form method="POST" action="">
            <label for="address">Wallet Address:</label><br>
            <input type="text" id="address" name="address" value="<?php echo htmlspecialchars($userData['wallet_address']); ?>" required readonly><br><br>
            <label for="amount">Amount (in USDT):</label><br>
            <input type="text" id="amount" name="amount" required><br><br>
            <button type="submit" name="withdraw">Process Withdrawal</button>
        </form>
        <button class="button-back-unique" onclick="window.location.href='faucet.php'">Back</button>
    </div>
</body>
</html>
