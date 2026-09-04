#!/bin/bash

mostrar_ayuda() {
    echo "=========================================================="
    echo " 🛠️  WSO2 Smart Sandbox - Script de Lanzamiento"
    echo "=========================================================="
    echo "Uso: ./run.sh [opción] [-clean]"
    echo ""
    echo "Opciones disponibles:"
    echo "  -apim      : Lanza SOLO el WSO2 API Manager."
    echo "  -is        : Lanza SOLO el WSO2 Identity Server."
    echo "  -is-apim   : Lanza AMBOS respetando los offsets del .env."
    echo ""
    echo "Modificadores:"
    echo "  -clean     : Destruye todo y lo reconstruye desde cero."
    echo "=========================================================="
}

if [ "$#" -eq 0 ]; then
    mostrar_ayuda
    exit 0
fi

MODO=""
CLEAN=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -apim) MODO="apim" ;;
        -is) MODO="is" ;;
        -is-apim) MODO="is-apim" ;;
        -clean) CLEAN=true ;;
        -h|--help) mostrar_ayuda; exit 0 ;;
        *) echo "❌ Opción desconocida o incorrecta: $1"; echo ""; mostrar_ayuda; exit 1 ;;
    esac
    shift
done

if [ -z "$MODO" ]; then
    echo "❌ Error: Debes especificar un modo (-apim, -is, o -is-apim)."
    exit 1
fi

export WSO2_MODE=$MODO

# ---------------------------------------------------------
# Magia Matemática: Calcular puertos dinámicamente
# ---------------------------------------------------------
if [ -f .env ]; then
    source .env
fi

export APIM_PORT=$((9443 + ${APIM_PORT_OFFSET:-0}))
export APIM_MGM_HTTP=$((9763 + ${APIM_PORT_OFFSET:-0}))
export APIM_GW_HTTPS=$((8243 + ${APIM_PORT_OFFSET:-0}))
export APIM_GW_HTTP=$((8280 + ${APIM_PORT_OFFSET:-0}))
export IS_PORT=$((9443 + ${IS_PORT_OFFSET:-3}))

echo "🚀 Lanzando WSO2 Smart Sandbox en modo: $MODO"
echo "🔌 Puertos Host -> APIM: $APIM_PORT | IS: $IS_PORT"
# ---------------------------------------------------------

if [ "$CLEAN" = true ]; then
    echo "🧹 Modo -clean: Destruyendo volúmenes antiguos y reconstruyendo..."
    docker-compose down -v
    docker-compose up --build
else
    echo "💾 Manteniendo estado: Levantando sin borrar..."
    docker-compose up
fi