# Define a imagem base. Usaremos uma imagem oficial do Python com Alpine, que é leve.
# A versão 3.11 é uma boa escolha, sendo estável e compatível com o projeto.
FROM python:3.11-alpine

# Define o diretório de trabalho dentro do contêiner.
# Todos os comandos subsequentes serão executados a partir deste diretório.
WORKDIR /app

# Copia o arquivo de dependências para o contêiner.
# Fazemos isso em um passo separado para aproveitar o cache de camadas do Docker.
# Se o requirements.txt não mudar, o Docker não reinstalará as dependências.
COPY requirements.txt .

# Instala as dependências do projeto.
# --no-cache-dir: Desabilita o cache do pip para manter a imagem menor.
# --upgrade pip: Garante que estamos usando a versão mais recente do pip.
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copia o restante do código da aplicação para o diretório de trabalho.
COPY . .

# Expõe a porta 8000, que é a porta padrão do Uvicorn.
# Isso permite que a aplicação seja acessada de fora do contêiner.
EXPOSE 8000

# Define o comando para executar a aplicação quando o contêiner for iniciado.
# Usamos "0.0.0.0" como host para que a aplicação seja acessível externamente.
# O --reload é removido, pois é recomendado apenas para desenvolvimento.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
