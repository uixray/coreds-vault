---
title: "Find White IP Script"
type: "meta"
status: "seed"
description: "Bash script for finding white/public IP addresses"
---

#!/bin/bash

# Настройки
INSTANCE_ID="fv451ju69r6p2u0l0l04"
FOLDER_ID="b1gnjhjr1gq690449h9a"
SUBNET_ID="fl8cd8cuhg8u8q0m63rv"
# Целевая подсеть (белый список)
TARGET_SUBNET="158.160.80"
MAX_ATTEMPTS=30
DELAY=10  # секунд между попытками

echo "🔍 Ищем IP из подсети $TARGET_SUBNET.x ..."
echo "Максимум попыток: $MAX_ATTEMPTS"
echo ""

for i in $(seq 1 $MAX_ATTEMPTS); do
    echo "--- Попытка $i из $MAX_ATTEMPTS ---"

    # Получаем текущий внешний IP
    CURRENT_IP=$(yc compute instance get $INSTANCE_ID \
        --folder-id $FOLDER_ID \
        --format json 2>/dev/null | \
        python3 -c "import sys,json; d=json.load(sys.stdin); print(d['network_interfaces'][0]['primary_v4_address']['one_to_one_nat']['address'])" 2>/dev/null)

    echo "Текущий IP: $CURRENT_IP"

    # Проверяем подсеть
    if [[ "$CURRENT_IP" == $TARGET_SUBNET.* ]]; then
        echo ""
        echo "✅ УСПЕХ! IP $CURRENT_IP находится в белом списке!"
        echo "Обновите конфиг VPN на новый IP: $CURRENT_IP"
        exit 0
    fi

    echo "❌ IP $CURRENT_IP не в целевой подсети, меняем..."

    # Удаляем текущий внешний IP
    yc compute instance remove-one-to-one-nat \
        $INSTANCE_ID \
        --network-interface-index 0 \
        --folder-id $FOLDER_ID \
        --quiet 2>/dev/null

    sleep 3

    # Назначаем новый IP
    yc compute instance add-one-to-one-nat \
        $INSTANCE_ID \
        --network-interface-index 0 \
        --folder-id $FOLDER_ID \
        --quiet 2>/dev/null

    echo "Ждём $DELAY секунд..."
    sleep $DELAY
done

echo ""
echo "❌ Не удалось найти IP из подсети $TARGET_SUBNET.x за $MAX_ATTEMPTS попыток"
echo "Попробуйте увеличить MAX_ATTEMPTS или запустить скрипт снова"
