#!/bin/bash
# By: soarespaullo

# Definição de cores
VERDE="\e[32m"
VERMELHO="\e[31m"
AZUL="\e[34m"
AMARELO="\e[33m"
RESET="\e[0m"

# Função para exibir um banner estilizado
exibir_banner() {
    echo -e "${AZUL}"
    echo -e "==========================================="
    echo -e "        🛠️ SCRIPT AUTOMÁTICO DE BACKUP      "
    echo -e "==========================================="
    echo -e "   🔹 Backup seguro e compacto com tar 🔹   "
    echo -e "   🔹 Com barra de progresso e validações 🔹"
    echo -e "==========================================="
    echo -e "${RESET}"
}

# Função para verificar e instalar o 'pv', se necessário
verificar_pv() {
    if ! command -v pv &> /dev/null; then
        echo -e "${VERMELHO}O utilitário 'pv' não está instalado. Instalando...${RESET}"
        sudo apt update && sudo apt install -y pv || { echo -e "${VERMELHO}Falha na instalação do pv!${RESET}"; exit 1; }
    fi
}

# Função para checar espaço disponível no destino
checar_espaco() {
    ESPACO_LIVRE=$(df -k "$DESTINO" | awk 'NR==2 {print $4}')
    TAMANHO_ORIGEM=$(du -sk "$ORIGEM" | awk '{print $1}')

    if [ "$ESPACO_LIVRE" -lt "$TAMANHO_ORIGEM" ]; then
        echo -e "${VERMELHO}Erro: Espaço insuficiente em $DESTINO!${RESET}"
        exit 1
    fi
}

# Função de backup
realizar_backup() {
    ARQUIVO_BACKUP="$DESTINO/backup_$(date +%Y%m%d%H%M%S).tar.gz"

    # Verifica se a origem existe
    if [ ! -d "$ORIGEM" ]; then
        echo -e "${VERMELHO}Erro: O diretório de origem não existe!${RESET}"
        exit 1
    fi

    # Cria o destino se não existir
    if [ ! -d "$DESTINO" ]; then
        echo -e "${VERDE}Criando diretório de destino...${RESET}"
        mkdir -p "$DESTINO"
    fi

    # Checa espaço disponível
    checar_espaco

    # Calcula o tamanho total dos arquivos
    TAMANHO_TOTAL=$(du -sb "$ORIGEM" | awk '{print $1}')

    # Realiza o backup com barra de progresso
    echo -e "${VERDE}Iniciando backup de ${AZUL}$ORIGEM${VERDE} para ${AZUL}$DESTINO${RESET}..."
    tar cf - "$ORIGEM" | pv -s "$TAMANHO_TOTAL" | gzip > "$ARQUIVO_BACKUP"

    # Mensagem final para orientar o usuário
    echo -e "${AMARELO}"
    echo -e "==========================================="
    echo -e "✅ Backup concluído com sucesso! 🎉"
    echo -e "📂 O arquivo foi salvo em: ${AZUL}$ARQUIVO_BACKUP${AMARELO}"
    echo -e "🔍 Para verificar o conteúdo, use:"
    echo -e "   tar -tzf $ARQUIVO_BACKUP"
    echo -e "🚀 Para restaurar, use:"
    echo -e "   tar -xzf $ARQUIVO_BACKUP -C /caminho/de/restauracao"
    echo -e "==========================================="
    echo -e "${RESET}"
}

# Exibe o banner inicial
exibir_banner

# Verifica e instala 'pv', se necessário
verificar_pv

# Solicita origem e destino ao usuário
echo -e "${AZUL}Digite o diretório de origem (ex: /home/usuário):${RESET}"
read ORIGEM
echo -e "${AZUL}Digite o diretório de destino (ex: /media/bkp):${RESET}"
read DESTINO

# Executa o backup
realizar_backup
