$folder = "C:\Users\MUHAMMAD\OneDrive\Desktop\MIRSAQ\cutomer details"
$port = 3001
$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Serving $folder on http://localhost:$port/"
while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $req = $ctx.Request
    $res = $ctx.Response
    $path = $req.Url.LocalPath.TrimStart('/')
    if ($path -eq '' -or $path -eq '/') { $path = 'MIRSAQ_Company_Profile.html' }
    $file = Join-Path $folder $path
    if (Test-Path $file) {
        $ext = [System.IO.Path]::GetExtension($file).ToLower()
        $mime = switch ($ext) { '.html' {'text/html'} '.css' {'text/css'} '.js' {'application/javascript'} '.png' {'image/png'} '.jpg' {'image/jpeg'} default {'application/octet-stream'} }
        $bytes = [System.IO.File]::ReadAllBytes($file)
        $res.ContentType = $mime
        $res.ContentLength64 = $bytes.Length
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $res.StatusCode = 404
    }
    $res.OutputStream.Close()
}
