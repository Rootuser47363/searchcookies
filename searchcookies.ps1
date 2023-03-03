# Función para buscar cookies en Google Chrome
function Get-ChromeCookies {
    $chrome_cookies_path = "$($env:LOCALAPPDATA)\Google\Chrome\User Data\Default\Cookies"
    if (Test-Path $chrome_cookies_path) {
        $cookies = New-Object -TypeName System.Collections.ArrayList
        $sqlite_path = "Data Source=$chrome_cookies_path;pooling=false"
        $query = "SELECT host_key, name, value, encrypted_value, expires_utc, is_secure, is_httponly, path FROM cookies"
        $command = New-Object -TypeName System.Data.SQLite.SQLiteCommand($query)
        $connection = New-Object -TypeName System.Data.SQLite.SQLiteConnection($sqlite_path)
        $connection.Open()
        $command.Connection = $connection
        $reader = $command.ExecuteReader()
        while ($reader.Read()) {
            $cookie = New-Object -TypeName PSObject -Property @{
                Browser = "Google Chrome"
                Host = $reader.GetValue(0)
                Name = $reader.GetValue(1)
                Value = $reader.GetValue(2)
                EncryptedValue = $reader.GetValue(3)
                Expires = [DateTime]::FromFileTimeUtc($reader.GetValue(4))
                IsSecure = $reader.GetValue(5)
                IsHttpOnly = $reader.GetValue(6)
                Path = $reader.GetValue(7)
            }
            $cookies.Add($cookie) | Out-Null
        }
        $reader.Close()
        $connection.Close()
        $cookies | Export-Csv -Path "$($env:USERPROFILE)\Desktop\ChromeCookies.txt" -NoTypeInformation
        return $cookies
    }
}

# Función para buscar cookies en Mozilla Firefox
function Get-FirefoxCookies {
    $firefox_cookies_path = "$($env:APPDATA)\Mozilla\Firefox\Profiles\*\cookies.sqlite"
    $firefox_profiles = Get-ChildItem -Path (Resolve-Path $firefox_cookies_path).Directory.Parent.FullName | Where-Object { $_.PSIsContainer }
    $cookies = New-Object -TypeName System.Collections.ArrayList
    foreach ($profile in $firefox_profiles) {
        $cookies_path = "$($profile.FullName)\cookies.sqlite"
        if (Test-Path $cookies_path) {
            $sqlite_path = "Data Source=$cookies_path;pooling=false"
            $query = "SELECT host, name, value, encrypted_value, expiry, isSecure, isHttpOnly, path FROM moz_cookies"
            $command = New-Object -TypeName System.Data.SQLite.SQLiteCommand($query)
            $connection = New-Object -TypeName System.Data.SQLite.SQLiteConnection($sqlite_path)
            $connection.Open()
            $command.Connection = $connection
            $reader = $command.ExecuteReader()
            while ($reader.Read()) {
                $cookie = New-Object -TypeName PSObject -Property @{
                    Browser = "Mozilla Firefox"
                    Host = $reader.GetValue(0)
                    Name = $reader.GetValue(1)
                    Value = $reader.GetValue(2)
                    EncryptedValue = $reader.GetValue(3)
                    Expires = [DateTime]::FromFileTimeUtc($reader.GetValue(4))
                    IsSecure = $reader.GetValue(5)
                    IsHttpOnly = $reader.GetValue(6)
                    Path = $reader.GetValue(7)
                }
                $cookies.Add($cookie) | Out-Null
            }
            $reader.Close()
            $connection.Close()
        }
    }
    $cookies | Export-Csv -Path "$($env:USERPROFILE)\Desktop\FirefoxCookies.txt" -No
New-Item -ItemType File -Path "C:\carpeta\nombre_archivo.ps1" -Value $null