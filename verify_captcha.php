<?php
session_start();
require_once 'db.php';

if (!isset($_SESSION['wallet_address'])) {
    header("Location: login.php");
    exit;
}

$captchaResponse = $_POST['h-captcha-response'];

if (!$captchaResponse) {
    $_SESSION['error'] = 'Captcha response missing';
    header("Location: faucet.php");
    exit;
}

// Obtener las claves de hCaptcha desde la base de datos
$hcaptchaQuery = $conn->prepare("SELECT setting_key, setting_value FROM settings WHERE setting_key LIKE 'hcaptcha_%_key'");
$hcaptchaQuery->execute();
$hcaptchaKeys = [];
foreach ($hcaptchaQuery->get_result() as $row) {
    $hcaptchaKeys[$row['setting_key']] = $row['setting_value'];
}

// Verificar hCaptcha
$hcaptchaSecret = $hcaptchaKeys['hcaptcha_secret_key'];
$verifyResponse = file_get_contents("https://hcaptcha.com/siteverify?secret={$hcaptchaSecret}&response={$captchaResponse}");
$responseData = json_decode($verifyResponse, true);

if (!$responseData) {
    $_SESSION['error'] = 'No response from hCaptcha';
    header("Location: faucet.php");
    exit;
}

if ($responseData['success']) {
    // Obtener la recompensa desde la base de datos
    $claimQuery = $conn->prepare("SELECT reward_amount FROM settings_claim WHERE id = 1");
    $claimQuery->execute();
    $claimConfig = $claimQuery->get_result()->fetch_assoc();
    $rewardAmount = $claimConfig['reward_amount'];

    // Actualizar balance del usuario
    $update = $conn->prepare("UPDATE Users SET balance = balance + ?, last_claim_time = NOW() WHERE wallet_address = ?");
    $update->bind_param("ds", $rewardAmount, $_SESSION['wallet_address']);
    $update->execute();

    if ($update->affected_rows > 0) {
        $_SESSION['success'] = 'READY';
        header("Location: faucet.php");
    } else {
        $_SESSION['error'] = 'Failed to update balance';
        header("Location: faucet.php");
    }
} else {
    // Registro detallado del error para depuración
    $errorCodes = isset($responseData['error-codes']) ? implode(', ', $responseData['error-codes']) : 'Unknown error';
    $_SESSION['error'] = 'Captcha verification failed: ' . $errorCodes;
    header("Location: faucet.php");
}
exit;
?>
