#!/system/bin/sh
  echo 1 > /sys/module/sec/parameters/recovery_done		#tony
if ! applypatch -c EMMC:recovery:18237440:0c53f6a9710466a76a82922ea7a9243f78ba6133; then
  log -t recovery "Installing new recovery image"
  applypatch  EMMC:boot:15384576:f8e2fbf96fca14899c1b1f428e8c64a4a935fa40 EMMC:recovery 0c53f6a9710466a76a82922ea7a9243f78ba6133 18237440 f8e2fbf96fca14899c1b1f428e8c64a4a935fa40:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
  if applypatch -c EMMC:recovery:18237440:0c53f6a9710466a76a82922ea7a9243f78ba6133; then		#tony
	echo 0 > /sys/module/sec/parameters/recovery_done		#tony
        log -t recovery "Install new recovery image completed"
        
  if applysig /system/etc/recovery.sig recovery; then
    sync
    log -t recovery "Apply recovery image signature completed"
  else
    log -t recovery "Apply recovery image signature fail!!"
  fi

    
  else
	echo 2 > /sys/module/sec/parameters/recovery_done		#tony
        log -t recovery "Install new recovery image not completed"
  fi
else
  echo 0 > /sys/module/sec/parameters/recovery_done              #tony
  log -t recovery "Recovery image already installed"
fi
if ! applypatch -c EMMC:tee2:1172992:a056c7d414281f3cbbda186fc9ffa6382e750153; then
  log -t recovery "Installing new TEE image"
  applypatch -t /system/tee.img EMMC:tee2:1172992:a056c7d414281f3cbbda186fc9ffa6382e750153 
else
  log -t recovery "TEE image already installed"
fi
