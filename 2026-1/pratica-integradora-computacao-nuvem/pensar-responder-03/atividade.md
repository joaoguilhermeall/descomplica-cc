Atividade Prática - Ferramentas e características de bancos de dados em nuvem

Título da Prática: Banco de dados na nuvem

Objetivos: Compreender novos recursos e ferramentas da nuvem com a criação de um Banco de Dados Relacional com o AWS RDS

Materiais, Métodos e Ferramentas: Acesso ao console AWS e ao AWS RDS.

Atividade Prática

Estudante, já parou para se perguntar por que necessitamos cada vez mais de bancos de dados? A internet, a popularização do comércio virtual e eletrônico, a expansão do uso dos smartphones e demais dispositivos conectados - todo esse cenário tecnológico - faz com que exista uma quantidade cada vez maior de dados sendo gerados.
Os dados de uso ou de compras que geramos ao navegar na internet, e que não são pessoais, podem ser utilizados pelas empresas para criar novos produtos e serviços, e até mesmo no processamento das requisições de cada usuário, como quando você, estudante, acessa algum serviço na nuvem.
Bancos de dados representam uma forma moderna de se armazenar dados e seu objetivo é de oferecer uma estrutura de armazenamento que receba os dados de forma organizada, para que as consultas sejam agilizadas. Os bancos de dados relacionais recebem este nome pois são criados em tabelas onde linhas e colunas apresentam os dados e a relação entre estes dados.
A computação na nuvem oferece excelentes opções de como lidar com bancos de dados, como criar estes bancos e administrar, e nesta atividade vamos criar um Banco de Dados Relacional com o AWS RDS seguindo os passos a seguir:

Passo 1. Para começar sua atividade acesse o portal AWS através do endereço: <www.aws.amazon.com> (Acesso em 02/08/2022) e efetue login:

​Passo 2. A página de Console de Gerenciamento de AWS será aberta:​

Passo 3. Uma vez conectado ao Console de Gerenciamento da AWS, em primeiro lugar, é necessário buscar pelo serviço, algo que pode ser feito facilmente se você digitar “RBS” no campo de pesquisa de seu console AWS, como mostra a figura a seguir:

Passo 4. A imagem a seguir representa o console do AWS RDS na forma com que foi disponibilizado em meados de 2022. Deixo esta informação caso você abra esta ferramenta em outro período e seu layout tenha sofrido alguma mudança:

​Passo 5. Para começar basta clicar no botão laranja “Criar Banco de dados”:​

Passo 6. Agora vamos às configurações e ao tipo de banco. Neste caso use as seguintes configurações:
a. Criação padrão
b. MySQL
c. Versão MySQL 8.0.28
d. NÍVEL GRATUITO

ATENÇÃO: Mesmo escolhendo o free tier, ou a instância gratuita, para seu exercício, lembre-se de excluir tudo o que for criado ao término e envio de sua atividade, como forma de garantir a inexistência de eventuais cobranças futuras.


​Fonte: Autor (2022)
​Passo 7. Crie um nome para sua instância, seu banco de dados:​


​Fonte: Autor (2022)
​Passo 8. Ainda na mesma tela, na sequência, vamos criar o usuário administrador do Banco de Dados e uma senha para seu acesso:​


​Fonte: Autor (2022)
​Passo 9. As configurações da instância e seu armazenamento podem ser mantidas como padrão, conforme a imagem a seguir demonstra:​


​Fonte: Autor (2022)
​Passo 10. Para as configurações de conectividade você deve apenas configurar como acesso público:​


​Fonte: Autor (2022)
​Passo 11. Agora já podemos clicar em “Criar banco de dados”:​


Fonte: Autor (2022)

Esta imagem ajuda a relembrar que existe um limite de 750 horas de uso dos serviços do AWS RDS de forma gratuita.

Passo 12. Com o banco de dados criado temos a seguinte tela exibida no consolide do RDS:


Fonte: Autor (2022)

Passo 13. Clique no nome de seu banco de dados para ter acesso aos detalhes:


Fonte: Autor (2022)

Passo 14. Ao clicar no nome do banco de dados a tela que será exibida em seu console será a seguinte:


Fonte: Autor (2022)

Passo 15. Esta tela contendo o “Endpoint” de seu banco de dados será a comprovação de que concluiu sua atividade com sucesso.

Passo 16. Antes de enviar o print de seu “Endpoint”, responda às seguintes perguntas:

a) Na sua visão, porque os bancos de dados são importantes?
b) Para qual aplicação você utilizaria o seu banco de dados gratuito na AWS RDS?

Passo 17. Envie sua resposta em um documento de texto com seu nome, curso, título da atividade, print do “endpoint” e a resposta das duas perguntas do passo 16!