#!/bin/bash

# estadisticas_accesos.sh
#
#     Muestra un gráfico de accesos por hora a un servidor Apache a partir de un archivo
#     de log de accesos
#

mensaje="Muestra un gráfico de accesos por hora a un servidor Apache a partir de un archivo de log de
accesos."

# Variables
ancho=50

if [ $# -lt 1 ]
then
        printf "Uso: $0 ARCHIVO\n$mensaje\n"
        exit 1
fi

# Defino un arreglo de horas desde 0 a 23
hs=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)

# Contabilizo la cantidad de accesos por cada hora
for h in $(cat $* | cut -d '[' -f2 | cut -d "]" -f1 | cut -d ' ' -f1 | cut -d ':' -f2 | sed 's/^0//')
do
        (( hs[$h]++ ))
done

# Calculo la máxima cantidad de accesos
max=0
for h2 in ${hs[@]}
do
        if [ "$h2" -gt "$max" ]
        then
                max=$h2
        fi
done

# Calculo la longitud de caracteres del máximo
longitud=${#max}

# Imprimo el gráfico
echo "HORA (ACCESOS)"
hora="0"
for h3 in ${hs[@]}
do
        # Para cada hora
        # Calculo la cantidad de numerales a imprimir
        c=$(( h3 * ancho / max ))

        # Imprimo la hora con formato "HH:MM"
        if [ $hora == "0" ]
        then
                printf " 0"
        else
                printf "%2.i" "$hora"
        fi
        printf ":00"

        # Imprimo la cantidad de accesos
        printf " (%$longitud.i) " "$h3"

        # Imprimo los numerales
        for (( i=0; i<$c; i++ ))
        do
                printf "#"
        done
        echo

        # Siguiente hora
        (( hora++ ))
done
