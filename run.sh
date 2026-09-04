#!/bin/bash

# Función para mostrar las opciones disponibles
mostrar_ayuda() {
    echo "=========================================================="
    echo " 🛠️  WSO2 Smart Sandbox - Script de Lanzamiento"
    echo "=========================================================="
    echo "Uso: ./run.sh [opción] [-clean]"
    echo ""
    echo "Opciones disponibles:"
    echo "  -apim      : Lanza SOLO el WSO2 API Manager (Puerto 9443)."
    echo "  -is        : Lanza SOLO el WSO2 Identity Server."
    echo "  -is-apim   : Lanza AMBOS (APIM e IS con offset)."
    echo ""
    echo "Modificadores:"
    echo "  -clean     : Destruye todo y lo reconstruye desde cero."
    echo "  -h, --help : Muestra este menú de ayuda."
    echo ""
    echo "Ejemplos:"
    echo "  ./run.sh -apim"
    echo "  ./run.sh -is-apim -clean"
    echo "=========================================================="
}

if [ "$#" -eq 0 ]; then
    mostrar_ayuda
    exit 0
fi

MODO=""
CLEAN=false

# 2. Leer las opciones
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

echo "🚀 Lanzando WSO2 Smart Sandbox en modo: $MODO"

export WSO2_MODE=$MODO

# 3. Lógica limpia vs persistente
if [ "$CLEAN" = true ]; then
    echo "🧹 Modo -clean: Destruyendo volúmenes antiguos y reconstruyendo..."
    docker-compose down -v
    docker-compose up --build
else
    echo "💾 Manteniendo estado: Levantando sin borrar..."
    docker-compose up
fi