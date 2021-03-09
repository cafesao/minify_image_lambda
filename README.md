# Otimizador de imagens Lambda

## O que este programa faz?

Este programa tem como principal responsabilidade otimizar imagens, diminuindo a resolução e mudando o formato.

## Como faço para rodar?

E bastante simples, você precisa de:

- Conta na AWS
- Acess Key e Secret Key de uma conta IAM da AWS

Primeiro no seu terminal execute o comando: `aws configure` e coloque suas credenciais.

Depois vá até a pasta com o comando `cd aws/script` e execute o script com o comando: `sh deploy.sh <Name> <FirstExecution>` substituindo `<Name>` pelo nome que você deseja dar a aplicação e `<FirstExecution>`, caso seja a primeira execução, coloque `true`, depois, para eventuais updates de codigo, coloque `false`

Então caso seja a primeira execução e o nome da aplicação seja Optimize, o comando ficara assim: `sh deploy.sh optimize true`

Depois crie uma pasta chamada images/ na raiz do projeto e coloque algumas fotos que você deseja (.jpg, jpeg ou .png) e depois volte a pasta com o comando `cd aws/script` e execute `sh copyImage.sh`.

Agora e so aguardar fazer o upload das fotos e ver no AWS S3 no bucket com o final _bucket-image_, ele ira criar uma pasta chamada _optimize/_, dentro estará suas fotos otimizadas.

Todos os recursos criados estará na AWS CloudFormation.
