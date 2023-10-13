#!/usr/bin/ksh

# Create a mksysb to an NFS mount point. After it is sucessfully done a file will be created.
# It will create directory named of the LPAR name and the mksysb will be saved there.
# In order to be able to write to a NFS filesystem, it has to have write permission by "nobody"

if [ $# -ne 2 ] ; then
  echo Usage $0 NFS_server FS_name_on_server
  exit 1
fi

TheNFSserver=$1
TheNFSFs=$2
#TheNFSserver=yyaix1.rchland.ibm.com
#TheNFSFs=/mksysbs
TMPMountPoint=/tmp/$$.1

Today=`date +%m%d%y`
LparName=`hostname -s`
MksysbName=${TMPMountPoint}/${LparName}/${LparName}_mksysb_${Today}
MksysbNameDone=${MksysbName}.done

trap 'cleanup' 2 6 15

cleanup()
{
  umount -f  ${TMPMountPoint}
  rmdir ${TMPMountPoint}
  echo quiting
  exit 5
}

mkdir ${TMPMountPoint}
if [ $? -ne 0 ] ; then
  echo Can not create mount point directory  ${TMPMountPoint}
  exit 1
fi

mount ${TheNFSserver}:${TheNFSFs} ${TMPMountPoint}
if [ $? -ne 0 ] ; then
  echo Can not mount NFS filesystem ${TMPMountPoint}:${TheNFSFs} to mount point ${TMPMountPoint}
  exit 2
fi

mkdir -p ${TMPMountPoint}/$LparName
if [ $? -ne 0 ] ; then
  echo Can not create directory ${TMPMountPoint}/$LparName
  exit 3
fi


if [ -f $MksysbNameDone ] ; then
  rm ${MksysbNameDone}
fi

/usr/bin/mksysb -e -i -X $MksysbName

if [ $? -eq 0 ] ; then
  touch $MksysbNameDone 
else
  echo mksysb is not created
  exit 4
fi

umount ${TMPMountPoint}
if [ $? -ne 0 ] ; then
  echo Can not umount the NFS filesystem ${TMPMountPoint}
else
  rmdir ${TMPMountPoint}
fi
