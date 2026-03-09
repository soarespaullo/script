# 🛠️ Interactive Backup Linux Tool

[![Bash Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
![Version](https://img.shields.io/badge/Version-1.0-blue?style=for-the-badge)

Um script Bash interativo e robusto para automação de backups em sistemas Linux. Desenvolvido para ser simples, seguro e visualmente informativo, ele facilita a rotina de administração de sistemas através de uma interface amigável diretamente no terminal.

## 🚀 Funcionalidades

* **Interatividade Total:** Utiliza `read -e` para permitir o uso de **TAB (auto-complete)** ao digitar os caminhos de diretórios.
* **Barra de Progresso:** Integração nativa com o utilitário `pv` (Pipe Viewer) para exibir o status da compressão em tempo real.
* **Validações Inteligentes:**
    * **Check de Origem:** Verifica a existência do diretório antes de iniciar o processo.
    * **Autocriação de Destino:** Cria o diretório de destino automaticamente caso ele não exista.
    * **Check de Espaço:** Compara o tamanho da origem com o espaço disponível no destino para evitar falhas por disco cheio.
* **Compressão Eficiente:** Utiliza `tar` combinado com `gzip` para gerar arquivos `.tar.gz` compactos e datados.
* **Interface Visual:** Saída personalizada com banners e alertas coloridos para melhor experiência do usuário.

## 📋 Requisitos

O script foi projetado para distribuições baseadas em **Debian/Ubuntu**. Ele possui uma função de auto-instalação para a dependência `pv`, mas certifique-se de ter os pacotes base:

- `bash`
- `tar`
- `gzip`
- `pv` (Pipe Viewer)

## ⚙️ Instalação e Uso

1. **Clone o repositório ou baixe o script:**
```
git clone https://github.com/soarespaullo/script.git
cd script
```

2. **Dê permissão de execução:**
```
chmod +x backup_linux.sh
```

3. **Execute o script:**

```
./backup_linux.sh
```
