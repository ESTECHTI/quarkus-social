# Quarkus Social

API REST em Quarkus para um cenário simples de rede social, com foco em:

- criação e listagem de posts
- seguir usuários
- listagem de seguidores

## Tecnologias

- Java 17+ (projeto compilado com release 17)
- Quarkus 3.21
- Quarkus REST
- Hibernate ORM com Panache
- MySQL (execução local padrão)
- H2 (apenas para testes)
- Lombok
- Maven Wrapper

## Estrutura do projeto

- src/main/java/com/example/social/quarkussocial/domain/model: entidades JPA
- src/main/java/com/example/social/quarkussocial/domain/repository: repositórios Panache
- src/main/java/com/example/social/quarkussocial/rest: endpoints REST
- src/main/java/com/example/social/quarkussocial/rest/dto: DTOs de request/response
- src/main/resources/application.properties: configuração padrão (MySQL)
- src/test/resources/application.properties: configuração de testes (H2 em memória)

## Pré-requisitos

- JDK 17 ou superior
- Maven (opcional, pois o projeto já inclui mvnw/mvnw.cmd)
- MySQL rodando localmente para execução da aplicação

## Configuração de banco (execução local)

Por padrão, a aplicação usa MySQL com os valores atuais em src/main/resources/application.properties:

- URL: jdbc:mysql://localhost:3306/quarkus-social
- usuário: developer
- senha: 123

Se necessário, ajuste esses valores antes de subir a aplicação.

## Seed rápido para testes locais

Como ainda não existe endpoint para cadastro de usuários, use o SQL abaixo para popular dados iniciais no MySQL.

```sql
USE `quarkus-social`;

INSERT INTO USERS (id, name, age) VALUES
	(1, 'Ana', 25),
	(2, 'Bruno', 30),
	(3, 'Carla', 28);

INSERT INTO followers (user_id, follower_id) VALUES
	(1, 2);

INSERT INTO posts (post_text, dateTime, user_id) VALUES
	('Primeiro post da Ana', NOW(), 1),
	('Segundo post da Ana', NOW(), 1);
```

Fluxo mínimo para validar endpoints após o seed:

```bash
# listar seguidores da Ana (userId=1)
curl -i http://localhost:8080/users/1/followers

# Bruno (followerId=2) pode visualizar posts da Ana
curl -i -H "followerId: 2" http://localhost:8080/users/1/posts

# Carla (followerId=3) não segue Ana e recebe 403
curl -i -H "followerId: 3" http://localhost:8080/users/1/posts
```

## Como executar

Modo desenvolvimento (hot reload):

```bash
./mvnw quarkus:dev
```

Aplicação disponível em:

- API: http://localhost:8080
- Dev UI (somente dev mode): http://localhost:8080/q/dev/

Build do projeto:

```bash
./mvnw clean package
```

Executar jar empacotado:

```bash
java -jar target/quarkus-app/quarkus-run.jar
```

## Testes

Executar testes:

```bash
./mvnw test
```

Observações sobre testes:

- os testes usam H2 em memória (não dependem do MySQL local)
- o endpoint de smoke test é GET /hello

## Endpoints disponíveis

### Health simples

- GET /hello
- resposta: 200 com texto Hello from Quarkus REST

### Seguidores

- PUT /users/{userId}/followers
	- body:

```json
{
	"followerId": 2
}
```

	- regras principais:
		- retorna 409 se userId for igual ao followerId
		- retorna 404 se o usuário alvo não existir
		- retorna 204 quando a relação é criada (ou já existe)

- GET /users/{userId}/followers
	- retorna 404 se o usuário não existir
	- retorna 200 com payload:

```json
{
	"followersCount": 1,
	"content": [
		{
			"id": 10,
			"name": "Maria"
		}
	]
}
```

### Posts

- POST /users/{userId}/posts
	- body:

```json
{
	"text": "Meu primeiro post"
}
```

	- retorna 404 se o usuário não existir
	- retorna 201 quando cria o post

- GET /users/{userId}/posts
	- header obrigatório: followerId
	- validações:
		- 404 se userId não existir
		- 400 se followerId não for enviado
		- 400 se followerId não existir
		- 403 se o followerId não seguir o usuário
	- resposta 200:

```json
[
	{
		"text": "Meu primeiro post",
		"dateTime": "2026-04-20T15:00:00"
	}
]
```

## Limitações atuais

- ainda não há endpoint REST para cadastro/listagem de usuários
- os endpoints de posts e seguidores assumem que os usuários já existem no banco
- há aviso de extensão JSON em tempo de execução; para serialização JSON explícita, considere adicionar quarkus-rest-jackson

## Referências

- Documentação Quarkus: https://quarkus.io/
