::Function detailing how to remotely start and stop the "RemoteRegistry" windows service.

net use \\0.0.0.0 /user:name Abc123
sc \\0.0.0.0 start "RemoteRegistry"
pause
sc \\0.0.0.0 stop "RemoteRegistry"
pause