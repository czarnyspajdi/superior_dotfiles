function lsblk --description 'alias lsblk=lsblk -o NAME,SIZE,LABEL,FSTYPE,MOUNTPOINTS,TRAN'
 command lsblk -o NAME,SIZE,LABEL,FSTYPE,MOUNTPOINT,TRAN $argv
        
end
