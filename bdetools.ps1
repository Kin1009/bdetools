$temp = "1"
while ($temp -eq "1")
    {
    $drive = Read-Host -Prompt "Enter drive (Example: `"C:`")"
    echo "Choose an option:"
    echo "1. Unlock using password"
    echo "2. Unlock using recovery password:"
    echo "3. Unlock using recovery key path"
    echo "4. Lock drive"
    echo "5. Encrypt drive"
    echo "6. Decrypt drive"
    echo "7. Change password"
    echo "8. Turn on auto-unlock"
    echo "9. Turn off auto-unlock"
    $choice = Read-Host -Prompt "Choose an option"
    while (!(("1", "2", "3", "4", "5", "6", "7", "8", "9").contains($choice)))
        {
        cls
        echo "Invalid choice. Please try again."
        $choice = Read-Host -Prompt "Choose (1, 2 or 3)"
        }
    cls
    if ($choice -eq "1")
        {
        $password = Read-Host -AsSecureString -Prompt "Enter password"
        cls
        echo "Trying to unlock drive $($drive)..."
        Unlock-BitLocker -MountPoint $drive -Password $password
        }
    elseif ($choice -eq "2")
        {
        $password = Read-Host -Prompt "Enter recovery password"
        cls
        echo "Trying to unlock drive $($drive)..."
        Unlock-BitLocker -MountPoint $drive -RecoveryPassword $password
        }
    elseif ($choice -eq "3")
        {
        $password = Read-Host -Prompt "Enter recovery key file path"
        cls
        echo "Trying to unlock drive $($drive)..."
        Unlock-BitLocker -MountPoint $drive -RecoveryKeyPath $password
        }
    elseif ($choice -eq "4")
        {
        echo "Trying to lock drive $($drive)..."
        Lock-BitLocker -MountPoint $drive -ForceDismount
        }
    elseif ($choice -eq "5")
        {
        $password = Read-Host -AsSecureString -Prompt "Enter password"
        $confpass = Read-Host -AsSecureString -Prompt "Confirm password"
        $method = Read-Host -Prompt "Choose the drive encryption method (1 for aes128, 2 for aes256, 3 for xts-aes128, 4 for xts-aes256)"
        while ($password -ne $confpass)
            {
                cls
                echo "Passwords don't match. Please try again."
                $password = Read-Host -AsSecureString -Prompt "Enter password"
                $confpass = Read-Host -AsSecureString -Prompt "Confirm password"
            }
        while (!(("1", "2", "3", "4").contains($method)))
            {
            echo "Invalid choice. Please try again."
            $method = Read-Host -Prompt "Choose the drive encryption method (1 for aes128, 2 for aes256, 3 for xts-aes128, 4 for xts-aes256)"
            }
        if ($method -eq "1")
            {
                Enable-BitLocker -MountPoint $drive -PasswordProtector -Password $password -EncryptionMethod Aes128
            }
        if ($method -eq "2")
            {
                Enable-BitLocker -MountPoint $drive -PasswordProtector -Password $password -EncryptionMethod Aes256
            }
        if ($method -eq "3")
            {
                Enable-BitLocker -MountPoint $drive -PasswordProtector -Password $password -EncryptionMethod XtsAes128
            }
        if ($method -eq "4")
            {
                Enable-BitLocker -MountPoint $drive -PasswordProtector -Password $password -EncryptionMethod XtsAes256
            }
        }
    elseif ($choice -eq "6")
        {
        cls
        echo "Trying to decrypt drive $($drive)..."
        Disable-BitLocker -MountPoint $drive
        }
    elseif ($choice -eq "7")
        {
        C:\Windows\system32\manage-bde.exe -changepassword $drive
        }
    elseif ($choice -eq "8")
        {
        Enable-BitLockerAutoUnlock -MountPoint $drive
        }
    elseif ($choice -eq "9")
        {
        Disable-BitLockerAutoUnlock -MountPoint $drive
        }
    timeout /t 3
    cls
    }