<script>
  powershell.exe Set-ExecutionPolicy RemoteSigned -Force
</script>
<powershell>

  Import-Module ECSTools
  Initialize-ECSAgent -Cluster "${cluster_name}" -EnableTaskIAMRole

  # We are assuming there is only one offline disk
  $OfflineDisks = Get-Disk | Where-Object IsOffline –Eq $True

  If ( $OfflineDisks ) {
    $OfflineDisks | Set-Disk -IsOffline $False
    $OfflineDisks | Set-Disk -IsReadOnly $False
    $OfflineDisks | Initialize-Disk -PartitionStyle MBR
    $OfflineDisks | New-Partition -UseMaximumSize -DriveLetter D
    Get-Volume -DriveLetter D | Format-Volume -FileSystem NTFS

    # Create the docker config and point to the new volume
    mkdir 'd:/docker'
    New-Item -Path 'C:\ProgramData\Docker\config\daemon.json' -Value '{ "data-root": "d:\\docker" }' -Force
  }

  # Restart service for settings to take effect
  Restart-Service docker -Force

  # Append addition user-data script
  ${additional_user_data_script}

</powershell>
