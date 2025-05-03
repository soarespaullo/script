#!/bin/bash
# #############################################################################
# Nome: backup_linux.sh
#
# Autor: Paulo Soares (soarespaullo@proton.me)
# Data de Criação: 10/04/2025
# Última Atualização: 10/05/2025
# Versão: 1.0
#
# Uso:
#   chmod +x backup_linux.sh   # Torna o script executável
#   ./backup_linux.sh          # Executa o script
#
# Requisitos:
#   - Bash shell
#   - Utilitário tar
#
# Histórico de Alterações:
#   v1.0 - 10/10/2023 - Criação inicial do script.
#
# Licença: GPL
# #############################################################################

# Definição de cores para saída no terminal
VERDE="\e[32m"
VERMELHO="\e[35m"
AZUL="\e[34m"
AMARELO="\e[33m"
RESET="\e[0m"

# Banner bem elaborado
exibir_banner() {
    echo -e "${AZUL}"
    echo "=================================================="
    echo "      🛠️  SCRIPT AUTOMÁTICO DE BACKUP             "
    echo "=================================================="
    echo "        Backup Seguro e Compacto com TAR          "
    echo "  Barra de Progresso, Validações e Auto-Complete  "
    echo "=================================================="
    echo -e "${RESET}"
}

# Função para verificar e instalar o 'pv' se não estiver instalado
verificar_pv() {
    if ! command -v pv &> /dev/null; then
        echo -e "${VERMELHO}O utilitário 'pv' não está instalado. Instalando...${RESET}"
        sudo apt update && sudo apt install -y pv || { 
            echo -e "${VERMELHO}Falha na instalação do pv!${RESET}"; 
            exit 1; 
        }
    fi
}

# Função para checar se há espaço suficiente no diretório de destino
checar_espaco() {
    # Obtém espaço livre disponível (em kilobytes) na partição onde DESTINO está localizado
    ESPACO_LIVRE=$(df -k "$DESTINO" | awk 'NR==2 {print $4}')
    # Obtém tamanho da origem (em kilobytes); du -sk retorna tamanho em KB
    TAMANHO_ORIGEM=$(du -sk "$ORIGEM" | awk '{print $1}')
    
    if [ "$ESPACO_LIVRE" -lt "$TAMANHO_ORIGEM" ]; then
        echo -e "${VERMELHO}Erro: Espaço insuficiente no destino '$DESTINO'!${RESET}"
        exit 1
    fi
}

# Função que realiza o backup utilizando tar e pv
realizar_backup() {
    # Nome do arquivo de backup com data/hora
    ARQUIVO_BACKUP="$DESTINO/backup_$(date +%Y%m%d%H%M%S).tar.gz"
    
    # Validação: verificação se a origem existe
    if [ ! -d "$ORIGEM" ]; then
        echo -e "${VERMELHO}Erro: O diretório de origem '$ORIGEM' não existe!${RESET}"
        exit 1
    fi

    # Se o diretório de destino não existir, ele será criado
    if [ ! -d "$DESTINO" ]; then
        echo -e "${VERDE}Criando diretório de destino: '$DESTINO'...${RESET}"
        mkdir -p "$DESTINO"
    fi

    # Checa se há espaço suficiente no destino
    checar_espaco

    # Calcula o tamanho total da origem (em bytes) para a barra de progresso
    TAMANHO_TOTAL=$(du -sb "$ORIGEM" | awk '{print $1}')

    echo -e "${VERDE}Iniciando backup de '${AZUL}$ORIGEM${VERDE}' para '${AZUL}$DESTINO${VERDE}'...${RESET}"
    # Cria o backup utilizando tar, com compressão gzip e com barra de progresso do pv
    tar cf - "$ORIGEM" | pv -s "$TAMANHO_TOTAL" | gzip > "$ARQUIVO_BACKUP"

    # Mensagem final com orientações sobre como visualizar/restaurar o backup
    echo -e "${AMARELO}"
    echo -e "=================================================="
    echo -e "✅ Backup concluído com sucesso! 🎉"
    echo -e "📂 O arquivo de backup foi salvo em:"
    echo -e "    ${AZUL}$ARQUIVO_BACKUP${AMARELO}"
    echo -e "🔍 Para verificar o conteúdo do backup, execute:"
    echo -e "   tar -tzf $ARQUIVO_BACKUP"
    echo -e "🚀 Para restaurar o backup, execute:"
    echo -e "   tar -xzf $ARQUIVO_BACKUP -C /caminho/de/restauracao"
    echo -e "=================================================="
    echo -e "${RESET}"
}

# Exibe o banner inicial
exibir_banner

# Verifica e instala o utilitário 'pv' se não estiver presente
verificar_pv

# Solicita interativamente o diretório de origem e destino com auto-complete
# O uso de "read -e" habilita o auto-complete (pressione TAB para completar)
echo -e "${AZUL}Digite o diretório de origem (use TAB para auto-completar):${RESET}"
read -e ORIGEM
echo -e "${AZUL}Digite o diretório de destino (use TAB para auto-completar):${RESET}"
read -e DESTINO

# Executa o backup
realizar_backup
