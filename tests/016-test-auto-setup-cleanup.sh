source $SRCDIR/libtest.sh

# Test using the "auto" driver
test_auto() {
  local test_status=0
  local testname=`basename "$0"`
  local infile=/etc/sysconfig/docker-storage-setup
  local outfile=/etc/sysconfig/docker-storage

  cat << EOF > /etc/sysconfig/docker-storage-setup
STORAGE_DRIVER=auto
EOF

 # Run container-storage-setup
 $CSSBIN >> $LOGS 2>&1

 # Test failed.
 if [ $? -ne 0 ]; then
    echo "ERROR: $testname: $CSSBIN failed." >> $LOGS
    rm -f $infile $outfile
    return 1
 fi

 if ! grep -q "overlay2" /etc/sysconfig/docker-storage; then
    echo "ERROR: $testname: /etc/sysconfig/docker-storage should have set overlay2 from the \"auto\" driver." >> $LOGS
    rm -f $infile $outfile
    return 1
 fi

 rm -f $infile $outfile
 return $test_status
}

test_auto
