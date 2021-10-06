#/bin/sh
solc $1 --ir-optimized --optimize > tmp.yul
yulc tmp.yul  -O3
rm tmp.yul

if [ -z $2 ]; then
    mv main.zasm $1.zasm
    mv main $1.bytecode
    exit 0
else
    mv main $2
    mv main.zasm $2.zasm
fi

