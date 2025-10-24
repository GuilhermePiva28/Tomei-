# 🚀 Instruções para Publicar no GitHub

## Passo 1: Criar Repositório no GitHub

1. Acesse [github.com](https://github.com) e faça login
2. Clique no botão **"+"** no canto superior direito
3. Selecione **"New repository"**
4. Configure o repositório:
   - **Repository name**: `Tomei`
   - **Description**: `Complete medication reminder app with offline notifications, color picker, and multilingual support - "Did I take it?" in Portuguese`
   - **Visibility**: Escolha **Public** ou **Private**
   - **NÃO** marque "Add a README file" (já temos um)
   - **NÃO** marque "Add .gitignore" (já temos um)
   - **License**: Selecione **MIT License** (opcional)
5. Clique em **"Create repository"**

## Passo 2: Conectar o Repositório Local ao GitHub

Após criar o repositório, o GitHub mostrará comandos. Use estes comandos no terminal:

```bash
# Adicionar o remote do GitHub (substitua SEU_USUARIO pelo seu nome de usuário)
git remote add origin https://github.com/SEU_USUARIO/Tomei.git

# Enviar o código para o GitHub
git push -u origin main
```

**Exemplo:**
```bash
git remote add origin https://github.com/guilherme/Tomei.git
git push -u origin main
```

## Passo 3: Verificar

1. Acesse `https://github.com/SEU_USUARIO/Tomei`
2. Você deve ver todos os arquivos e o README.md formatado

## 📝 Comandos Git Úteis para o Futuro

### Para fazer novos commits:
```bash
# Ver status das alterações
git status

# Adicionar arquivos alterados
git add .

# Fazer commit
git commit -m "Descrição das mudanças"

# Enviar para o GitHub
git push
```

### Para criar releases/versões:
```bash
# Criar uma tag de versão
git tag -a v1.0.0 -m "Release v1.0.0"

# Enviar a tag para o GitHub
git push origin v1.0.0
```

## 🎯 Próximos Passos Recomendados

1. **Adicionar Screenshots**:
   - Tire screenshots do app rodando
   - Crie uma pasta `screenshots/` no repositório
   - Adicione as imagens ao README.md

2. **Criar Release no GitHub**:
   - Vá em "Releases" no repositório
   - Clique em "Create a new release"
   - Anexe o APK gerado em `build/app/outputs/flutter-apk/app-release.apk`

3. **Adicionar Badge de Build**:
   - Configure GitHub Actions para build automatizado
   - Adicione badges ao README (build status, versão, etc.)

4. **Documentar API de Contribuição**:
   - Crie um arquivo `CONTRIBUTING.md`
   - Defina guidelines para pull requests

## 🔒 Arquivo .gitignore Atual

O arquivo `.gitignore` já está configurado para:
- ✅ Ignorar arquivos de build
- ✅ Ignorar cache do Flutter/Dart
- ✅ Ignorar arquivos gerados (*.g.dart)
- ✅ Manter arquivos de localização necessários

## ⚠️ Avisos Importantes

1. **Nunca commite**:
   - Chaves de API privadas
   - Senhas ou tokens
   - Arquivos de keystore (para releases)

2. **Antes de tornar público**:
   - Substitua IDs de teste do AdMob por IDs reais
   - Verifique se não há informações sensíveis no código
   - Teste o app completamente

3. **Para publicar na Play Store**:
   - Configure signing keys no Android
   - Atualize o `build.gradle` com versão correta
   - Gere um App Bundle: `flutter build appbundle --release`

---

**Repositório criado e pronto para publicação! 🎉**
