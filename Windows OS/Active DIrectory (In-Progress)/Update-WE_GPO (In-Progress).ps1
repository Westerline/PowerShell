<#
To do: (1) separate gpresult command (2) take before/after snapshots of GPO and see what changed
#>
gpupdate /force
gpresult /Scope User /v