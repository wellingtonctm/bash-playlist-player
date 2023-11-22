# BASH PLAYLIST PLAYER

Uma aplicação escrita em *Bash Script* para tocar playlists do YouTube no Terminal usando *yt-dlp* e *mpv*


## Requisitos

Para que seja possível utilizar esta aplicação, você deve instalar as seguintes dependências:

- yt-dlp
- mpv
- zenity
- libnotify-bin (debian)
- libnotify-osd (ubuntu)


## Instalação

Para fazer a instalação da aplicação no sistema para todos os usuários, basta executar o seguinte comando:

```bash
./build.sh && cd build && sudo ./install
```


## Uso

Caso esteja instalado, use o camando:

```bash
bash-playlist-player
```


Caso não esteja:

```bash
./main.sh
```
