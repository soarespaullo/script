# Como Funciona o Script
**Banner e Cores**: Ao iniciar, o script exibe um banner colorido e informativo, definindo o tom para um backup seguro e automatizado.

**Verificação do PV**: O script verifica se o utilitário `pv` está instalado e, se não estiver, atualiza os repositórios e instala-o. Essa etapa é vital para a exibição da barra de progresso.

**Entrada Interativa com Auto-Complete**: Utilizando `read -e`, o Bash permite que você use a tecla TAB para auto completar caminhos de diretórios, facilitando a seleção.

**Validações e Criação do Diretório de Destino**: Ele valida se o diretório de origem existe e, se o destino não existir, o cria automaticamente. Em seguida, checa se há espaço disponível suficiente no destino.

**Backup com Barra de Progresso**: Após calcular o tamanho total da origem, o comando `tar` é executado em conjunto com `pv` para exibir uma barra de progresso enquanto o backup é compactado com `gzip`.

**Mensagem Final**: Ao final, o script informa onde o backup foi salvo e orienta como listar e restaurar o backup.
