//Bibliotecas importadas //<>//
import ProcessingEngine.*; 
import processing.sound.*;

//Classes instanciadas
AudioIn in;
Amplitude amp;

Input Input; 
UI UI;
Collider Collider;

Game g; 
CommonControls c; 
Bola b;  
Jogador j[];

PApplet pa;


void setup()
{
  size(1280, 732);
  
  in = new AudioIn(this, 1);
  amp = new Amplitude(this);

  Input = new Input(); 
  Collider = new Collider(); 
  UI = new UI();
  
  pa = this;
  
  g = new Game(); 
  c = new CommonControls(); 
  b = new Bola();
  j = new Jogador[2];
  
  g.PingPongFont = createFont("PingPongFont.ttf", 32); textFont(g.PingPongFont); 
  
  g.pingFX = new SoundFile(this, "pingFX.aiff");
  g.soundtrack = new SoundFile(this, "soundtrack.aiff");
  
  g.comSom = loadImage("comSomIco.png");
  g.semSom = loadImage("semSomIco.png");
  g.comMicrofone = loadImage("comMicrofoneIco.png");
  g.semMicrofone = loadImage("semMicrofoneIco.png");
  
  g.p1up_key = 'w'; 
  g.p2up_key = UP; 
  g.p1down_key = 's'; 
  g.p2down_key = DOWN;
  
  g.levelIndex = 0;
  g.direcoes = new int[]{-1, 1};
  g.duracaoAnimacao = 1;
  g.tempo = 0;
  
  g.audio = true;
  g.microfone = false;
  g.estaFazendoAnimacao = true;
  g.isLoopingSoundtrack = false;
  
  g.posicaoSliders = new float[1];

  for(int x = 0; x < j.length; x++)
  {
    j[x] = new Jogador();
    j[x].largura = 20;
    j[x].altura = 100;
    j[x].partesPersonagem = 5;
    j[x].alturaBloco = j[x].altura / j[x].partesPersonagem;
  }

  b.altura = 15;
  b.largura = 15;
  b.direcaoHorizontal = 1;
  
  g.SpawnObjetos();
  
  in.start(0);
  amp.input(in);
}
void draw()
{
  stroke(0, 255, 0);
  background(0); 
  stroke(255); 
  fill(255);
  
  g.Niveis(g.levelIndex);
}
void keyPressed()
{
  if(!g.estaFazendoAnimacao)
  {
    if(keyCode == g.p2up_key)
      g.p2up_pressed = true;
    else if(key == g.p1up_key)
      g.p1up_pressed = true;
    else if(keyCode == g.p2down_key)
      g.p2down_pressed = true;
    else if(key == g.p1down_key)
      g.p1down_pressed = true; 
      
    if(key == 27)
    {
      key = 0;
    
      if(g.levelIndex == 6)
        g.menuAberto = !g.menuAberto;
    }
  }
}
void keyReleased()
{
  if(!g.estaFazendoAnimacao)
  {
    if(keyCode == g.p2up_key)
      g.p2up_pressed = false;
    else if(key == g.p1up_key)
      g.p1up_pressed = false;
    else if(keyCode == g.p2down_key)
      g.p2down_pressed = false;
    else if(key == g.p1down_key)
      g.p1down_pressed = false;
  }
}
void mousePressed()
{
  if(!g.estaFazendoAnimacao)
  {
    for (int x = 0; x < g.estaNoBotao.length; x++)
     {
       if(g.estaNoBotao[x])
       {
         if(g.levelIndex != 6)
           g.AcoesBotoes(x);
         else if(g.levelIndex == 6 && g.menuAberto)
           g.AcoesBotoes(x);
       }
     }
  }
  else
  {
    switch(g.levelIndex)
    {
      case 1:
        if(g.duracaoAnimacao < height - 150)
          g.estaFazendoAnimacao = false;
        break;
    }
  }
}

class Game
{
  int pontosj1, pontosj2, levelIndex, contador;
  int[] direcoes;
  float duracaoAnimacao, tempo;
  float[] posicaoSliders;
  char p1up_key, p2up_key, p1down_key, p2down_key;
  boolean p1up_pressed, p2up_pressed, p1down_pressed, p2down_pressed, multiplayer, menuAberto, audio, microfone, estaFazendoAnimacao, isLoopingSoundtrack;
  boolean[] estaNoBotao;
  
  PFont PingPongFont;
  SoundFile pingFX, soundtrack; 
  PImage semSom, comSom, comMicrofone, semMicrofone;
  
  void SpawnObjetos()
  {
    j[0].Spawn(width / 64, height / 2 - j[0].altura / 2); 
    j[1].Spawn(width - width / 64 - j[1].largura, height / 2 - j[1].altura / 2); 
    b.Spawn(width / 2 - b.largura / 2, height / 2 - b.altura / 2);
  }
  
  void Niveis(int levelIndex)
  {
    if(levelIndex >= 0 && levelIndex < 6)
      Menu(levelIndex);
    else
      switch(levelIndex)
      {
        case 6:
          NivelUm();
          break;
        
        case 7:
          GameOver();
          break;
      }
    
    if(!estaFazendoAnimacao && levelIndex != 0)
    {
      if(audio)
      {
        if(!isLoopingSoundtrack)
        {
          isLoopingSoundtrack = true;
          soundtrack.loop(1, 0.05);
        }
      }
      else
      {
        isLoopingSoundtrack = false;
        soundtrack.stop();
      }
    }
  }
  void Menu(int parteMenu)
  {
    menuAberto = false;

    switch(parteMenu)
    {
      case 0:
        if(!estaFazendoAnimacao)
        {
           duracaoAnimacao = height + 175;
           levelIndex = 1;
           estaFazendoAnimacao = true;
        }
        else
        {
          if(duracaoAnimacao != 0)
          {
            textSize(20);
            if(duracaoAnimacao < 255)
            {
              fill(255, 255, 255, duracaoAnimacao - 30);
              text("ESSE JOGO É UMA VARIAÇÃO BASEADA EM 'PONG', DA ATARI INC., DE 1972,  E FORA DESENVOLVIDO", width / 2 - textWidth("ESSE JOGO É UMA VARIAÇÃO BASEADA EM 'PONG', DA ATARI INC., DE 1972,  E FORA DESENVOLVIDO'.") / 2, height / 2 - textAscent() / 2);
              text("USANDO A LINGUAGEM DE PROGRAMAÇÃO PROCESSING E SUA 'LANGUAGE REFERENCE', SEM", width / 2 - textWidth("USANDO A LINGUAGEM DE PROGRAMAÇÂO PROCESSING E SUA 'LANGUAGE REFERENCE', SEM") / 2, height / 2 + textAscent() / 2);
              text("POSSUIR QUAISQUER FINS LUCRATIVOS", width / 2 - textWidth("POSSUIR QUAISQUER FINS LUCRATIVOS") / 2, height / 2 + (textAscent() / 2) * 2.95);
              duracaoAnimacao += 0.85;
            }
            else if(duracaoAnimacao < 510)
            {
              fill(255, 255, 255, (255 - (duracaoAnimacao - 255)) - 30);
              text("ESSE JOGO É UMA VARIAÇÃO BASEADA EM 'PONG', DA ATARI INC., DE 1972,  E FORA DESENVOLVIDO", width / 2 - textWidth("ESSE JOGO É UMA VARIAÇÃO BASEADA EM 'PONG', DA ATARI INC., DE 1972,  E FORA DESENVOLVIDO'.") / 2, height / 2 - textAscent() / 2);
              text("USANDO A LINGUAGEM DE PROGRAMAÇÃO PROCESSING E SUA 'LANGUAGE REFERENCE', SEM", width / 2 - textWidth("USANDO A LINGUAGEM DE PROGRAMAÇÂO PROCESSING E SUA 'LANGUAGE REFERENCE', SEM") / 2, height / 2 + textAscent() / 2);
              text("POSSUIR QUAISQUER FINS LUCRATIVOS", width / 2 - textWidth("POSSUIR QUAISQUER FINS LUCRATIVOS") / 2, height / 2 + (textAscent() / 2) * 2.95);
              duracaoAnimacao += 0.85;
            }
            else
              duracaoAnimacao = 0;
          }
          else
            estaFazendoAnimacao = false;
        }
        break;
      case 1:
        if(!estaFazendoAnimacao)
        {
          estaNoBotao = new boolean[4];
          textSize(196);
          
          text("PONG", width / 2 - textWidth("PONG") / 2, height / 4);
        
          UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 1, "", 55);
        
          estaNoBotao[0] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 1, "COMEÇAR", 55);
          estaNoBotao[1] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 2.75, "CONFIGURAÇÔES", 55);
          estaNoBotao[2] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 4.5, "CRÉDITOS", 55);
          estaNoBotao[3] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 6.25, "SAIR", 55);
          
          fill(255);
          square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * 1 - textAscent() / 2 + 7.5, 15);
          square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * 2.75 - textAscent() / 2 + 7.5, 15);
          square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * 4.5 - textAscent() / 2 + 7.5, 15);
          square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * 6.25 - textAscent() / 2 + 7.5, 15);
        }
        else
        {
          if(duracaoAnimacao >= height / 30 - 75)
          {
            textSize(196);
            
            text("PONG", width / 2 - textWidth("PONG") / 2, height + textAscent() - (height - duracaoAnimacao));
            duracaoAnimacao -= 2.15;
          }
          else
            estaFazendoAnimacao = false;
        }
        break;
      
      case 2:
        estaNoBotao = new boolean[3];
        
        textSize(196);
        text("PONG", width / 2 - textWidth("PONG") / 2, height / 4);
        
        textSize(45);

        if(audio)
          estaNoBotao[0] = UI.CriarBotoes(pa, 'i', comSom, width - width / 13, height - (height / 16) - 50, 50, 50);
        else
          estaNoBotao[0] = UI.CriarBotoes(pa, 'i', semSom, width - width / 13, height - (height / 16) - 50, 50, 50);

        text("On / Off", width / 2 + width / 16, height / 2 + textAscent() / 2);
        if(microfone)
          estaNoBotao[1] = UI.CriarBotoes(pa, 'i', comMicrofone, width - width / 4 + width / 32, height / 2, 50, 50);
        else
          estaNoBotao[1] = UI.CriarBotoes(pa, 'i', semMicrofone, width - width / 4 + width / 32, height / 2, 50, 50);  
        
        text("Microfone", width - width / 4 - width / 256, height / 2 - height / 16);
        text("Sensibilidade", width / 2 + width / 16, height / 2 + height / 16 * 2 + textAscent() / 2);
        posicaoSliders[0] = UI.CriarSlider(pa, width - width / 4 + width / 64, height / 2 + height / 16 * 2, 100);

        fill(255);
        text("Controles", width / 2 - width / 4 + width / 128, height / 2 - height / 16);
        text("P1", width / 2 - width / 4, height / 2 + textAscent() / 2);
        text("P2", width / 2 - width / 4 + width / 10, height / 2 + textAscent() / 2);
        text("Cima", width / 2 - width / 4 - width / 8, height / 2 + height / 16 * 2 + textAscent() / 2);
        text("Baixo", width / 2 - width / 4 - width / 8, height / 2 + height / 8 * 2 + textAscent() / 2);
        text("W", width / 2 - width / 4, height / 2 + height / 16 * 2 + textAscent() / 2);
        text("S", width / 2 - width / 4, height / 2 + height / 8 * 2 + textAscent() / 2);
        text("UP", width / 2 - width / 4 + width / 10, height / 2 + height / 16 * 2 + textAscent() / 2);
        text("DOWN", width / 2 - width / 4 + width / 10, height / 2 + height / 8 * 2 + textAscent() / 2);

        estaNoBotao[2] = UI.CriarBotoes(pa, 't', width / 13, height - (height / 16), "VOLTAR", 55);
        break;
      
      case 3:
        estaNoBotao = new boolean[1];
        textSize(196);
        
        text("PONG", width / 2 - textWidth("PONG") / 2, height / 4);
        
        textSize(45);
        text("IDEALIZAÇÃO DA ARTE, SONORIZAÇÃO E MECÂNICAS", width / 2 - textWidth("IDEALIZAÇÃO DA ARTE, SONORIZAÇÃO E MECÂNICAS") / 2, height / 2 + ((height / 2) / 8) * 0);
        text("PROGRAMAÇÃO", width / 2 - textWidth("PROGRAMAÇÃO") / 2, height / 2 + ((height / 2) / 8) * 3.75);
        
        textSize(30);
        text("BERNARDO MIGUEL GERÔNIMO DA CRUZ SILVA", width / 2 - textWidth("BERNARDO MIGUEL GERÔNIMO DA CRUZ SILVA") / 2, height / 2 + ((height / 2) / 8) * 0.75);
        text("LUCAS MARTIN MACEDO GAGLIANO", width / 2 - textWidth("LUCAS MARTIN MACEDO GAGLIANO") / 2, height / 2 + ((height / 2) / 8) * 4.5);
        
        textSize(20);
        text("RA: 21424187", width / 2 - textWidth("RA: 21424187") / 2, height / 2 + ((height / 2) / 8) * 1.25);
        text("RA: 21412302", width / 2 - textWidth("RA: 21412302") / 2, height / 2 + ((height / 2) / 8) * 5);
        estaNoBotao[0] = UI.CriarBotoes(pa, 't', width / 13, height - (height / 16), "VOLTAR", 55);
        break;
      
      case 4:
        estaNoBotao = new boolean[3];
        textSize(196);
        
        text("PONG", width / 2 - textWidth("PONG") / 2, height / 4);
        UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 1, "", 55);
        
        estaNoBotao[0] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 1, "1 JOGADOR", 55);
        estaNoBotao[1] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 2.75, "2 JOGADORES", 55);
        estaNoBotao[2] = UI.CriarBotoes(pa, 't', width / 13, height - (height / 16), "VOLTAR", 55);
        
        fill(255);
        square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * 1 - textAscent() / 2 + 7.5, 15);
        square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * 2.75 - textAscent() / 2 + 7.5, 15);
        break;
        
      case 5:
        estaNoBotao = new boolean[4];
        textSize(196);
        
        text("PONG", width / 2 - textWidth("PONG") / 2, height / 4);
        UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 1, "", 55);
          
        estaNoBotao[0] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 1, "FÁCIL", 55);
        estaNoBotao[1] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 2.75, "MÉDIO", 55);
        estaNoBotao[2] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 4.5, "DIFÍCIL", 55);
        estaNoBotao[3] = UI.CriarBotoes(pa, 't', width / 13, height  - (height / 16), "VOLTAR", 55); 
          
        fill(255);
        square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * 1 - textAscent() / 2 + 7.5, 15);
        square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * 2.75 - textAscent() / 2 + 7.5, 15);
        square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * 4.5 - textAscent() / 2 + 7.5, 15);
        break;
    }
  }
  
  void NivelUm()
  {
    int ladoMenu = 500;
    int numeroDivisoesRedeTotais = 20;
    int espacoDivisaoRede = 12;
    int alturaDivisaoRede = 36;
    int larguraDivisaoRede = 5; 
    
    b.Colidir();
    b.Mover(); 
    
    for(int x = 0; x < numeroDivisoesRedeTotais * 48; x += 48)
      rect(width / 2 - larguraDivisaoRede / 2, x + espacoDivisaoRede, larguraDivisaoRede, alturaDivisaoRede);
      
    text(pontosj1, width / 4 - textWidth(char(pontosj1)) / 2, height / 8);
    text(pontosj2, width / 2 + width / 4 - textWidth(char(pontosj2)) / 2, height / 8);
      
    if(!multiplayer)
    {
      j[0].Mover("Player", p1up_pressed, p1down_pressed);
      j[1].Mover("AI");
    }
    else
    {
      j[0].Mover("Player", p1up_pressed, p1down_pressed);
      j[1].Mover("Player", p2up_pressed, p2down_pressed);
    }
      
    if(pontosj1 == 5 || pontosj2 == 5)
      levelIndex = 7;
    
    if(menuAberto)
    {
      estaNoBotao = new boolean[2];
      
      fill(0);
      square(width / 2 - ladoMenu / 2, height / 2 - ladoMenu / 2, ladoMenu);
    
      fill(255);
      textSize(125);
      text("PAUSE", width / 2 - textWidth("PAUSE") / 2, height / 2 - ladoMenu / 2 + height / 4);
      
      UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 1, "", 55);
      
      estaNoBotao[0] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 1, "VOLTAR AO JOGO", 55);
      estaNoBotao[1] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 2.75, "MENU", 55); 
      
      fill(255);
      square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * 1 - textAscent() / 2 + 7.5, 15);
      square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * 2.75 - textAscent() / 2 + 7.5, 15);
    }
  }

  void GameOver()
  {
    textSize(55);
    estaNoBotao = new boolean[1];
    
    if(!multiplayer)
    {
      if(pontosj1 == 5)
        text("PLAYER 1 WON!", width / 2 - textWidth("PLAYER 1 WON!") / 2, height / 4);  
      else if(pontosj2 == 5)
        text("CPU WON!", width / 2 - textWidth("CPU WON!") / 2, height / 4);
    }
    else
    {
      if(pontosj1 == 5)
        text("PLAYER 1 WON!", width / 2 - textWidth("PLAYER 1 WON!") / 2, height / 4);
      else if(pontosj2 == 5)
        text("PLAYER 2 WON!", width / 2 - textWidth("PLAYER 2 WON!") / 2, height / 4);
    }
    
    estaNoBotao[0] = UI.CriarBotoes(pa, 't', width / 2 - textWidth("ABCDEFGH") / 2, height / 2 + ((height / 2) / 8) * 2.75, "MENU", 55);
    
    fill(255);
    square(width / 2 - textWidth("ABCDEFGH") / 2 - 50 / 2, height / 2 + ((height / 2) / 8) * 2.75 - textAscent() / 2, 15);
  }
  
  void AcoesBotoes(int indexBotao)
  {
    switch(levelIndex)
    {
      case 1:
        switch(indexBotao)
        {
          case 0:
            levelIndex = 4;
            break;
          case 1:
            levelIndex = 2;
            break;
          case 2:
            levelIndex = 3;
            break;
          case 3:
            exit();
            break;
        }
        break;
      case 2:
        switch(indexBotao)
        {
          case 0:
            if(audio)
              audio = false;
            else
              audio = true;
            break;
          case 1:
            if(microfone)
              microfone = false;
            else
              microfone = true;
            break;
          case 2:
            levelIndex = 1;
            break;
        }
        break;
      case 3:
        switch(indexBotao)
        {
          case 0:
            levelIndex = 1;
            break;
        }
        break;
      case 4:
        switch(indexBotao)
        {
          case 0:
            levelIndex = 5;
            multiplayer = false;
            break;
          case 1:
            levelIndex = 6;
            multiplayer = true;
            break;
          case 2:
            levelIndex = 1;
            break;
        }
        break;
      case 5:
        switch(indexBotao)
        {
          case 0:
            b.direcaoHorizontal = direcoes[parseInt(random(-1, 2))];
            j[1].multiplicador = 1.035;
            levelIndex = 6;
            break;
          case 1:
            b.direcaoHorizontal = direcoes[parseInt(random(-1, 2))];
            j[1].multiplicador = 1.065;
            levelIndex = 6;
            break;
          case 2:
            b.direcaoHorizontal = direcoes[parseInt(random(-1, 2))];
            j[1].multiplicador = 1.095;
            levelIndex = 6;
            break;
          case 3:
            levelIndex = 4;
            break;
        }
        break;
      case 6:
        switch(indexBotao)
        {
          case 0:
            g.menuAberto = false;
            break;
          case 1:
            levelIndex = 1;
            pontosj1 = 0;
            pontosj2 = 0;
            SpawnObjetos();
            break;
        }
        break;
      case 7:
        switch(indexBotao)
        {
          case 0:
            levelIndex = 1;
            pontosj1 = 0;
            pontosj2 = 0;
            break;
        }
        break;
    }
  }
}
  

class Jogador
{
  int partesPersonagem, largura, altura, alturaBloco;
  float posicaoAtualY, posicaoAtualX, multiplicador;

  void Spawn(float posicaoInicialX, float posicaoInicialY)
  {
    posicaoAtualY = posicaoInicialY;
    posicaoAtualX = posicaoInicialX;
  }
  
  void Mover(String tipoJogador, boolean teclaPositiva, boolean teclaNegativa)
  {
    float forcaMovimentoVertical = 6.5;
    
    if(!g.menuAberto)
    {
      switch(tipoJogador)
      {
        case "Player":
          if(!g.microfone)
          {
            float h = Input.GetAxis("Vertical", teclaPositiva, teclaNegativa);
            posicaoAtualY += forcaMovimentoVertical * h;
          }
          else
          {
            if(g.multiplayer)
            {
              float h = Input.GetAxis("Vertical", teclaPositiva, teclaNegativa);
              posicaoAtualY += forcaMovimentoVertical * h;
            }
            else
            {
              if(amp.analyze() > g.posicaoSliders[0] / 1000)
                posicaoAtualY -= forcaMovimentoVertical;
               else
                 posicaoAtualY += forcaMovimentoVertical + forcaMovimentoVertical * amp.analyze();
            }
          }
          break;
        
        case "AI":
          if(b.direcaoHorizontal == 1 || b.direcaoHorizontal == -1)
          {
            g.tempo += (millis() / 1000 / 60) / (millis() / 100);
            if(g.tempo >= 3)
            {
              g.tempo = 0;
              forcaMovimentoVertical = random(6, 6.5);
            }
            
            if(posicaoAtualY <= b.posicaoAtualY && posicaoAtualY + altura >= b.posicaoAtualY + b.altura)
              posicaoAtualY += 0;
            else if(b.posicaoAtualY > posicaoAtualY)
              posicaoAtualY += forcaMovimentoVertical * multiplicador;
            else if(b.posicaoAtualY + b.altura < posicaoAtualY + altura)
              posicaoAtualY -= forcaMovimentoVertical * multiplicador;
          }
          break;
      }
    }
    
    for (int x = 0; x < partesPersonagem; x++)
      rect(posicaoAtualX, posicaoAtualY + (alturaBloco * x), largura, alturaBloco);
    
    if(posicaoAtualY <= 0)
      posicaoAtualY = 0;
    else if(posicaoAtualY + altura >= height)
        posicaoAtualY = height - altura;
  }
  void Mover(String jogador)
  {
    Mover(jogador, false, false);
  }
}

class Bola
{
  int largura, altura;
  float direcaoHorizontal, posicaoAtualX, posicaoAtualY, angulacao, direcaoVertical;
  
  void Spawn(float posicaoInicialX, float posicaoInicialY)
  {
    posicaoAtualX = posicaoInicialX;
    posicaoAtualY = posicaoInicialY;
    
    angulacao = random(1.25, 2);
    direcaoVertical = random(-1, 1);
  }
  
  void Mover()
  {
    if(!g.menuAberto)
    {
      float forcaMovimentoHorizontal = 5.205;
      float forcaMovimentoVertical = 4.75;
      
      posicaoAtualY += direcaoVertical * forcaMovimentoVertical * angulacao;
      posicaoAtualX += direcaoHorizontal * forcaMovimentoHorizontal;
    }
    
    //image(g.rostoFabio, posicaoAtualX, posicaoAtualY, 200, 200);
    rect(posicaoAtualX, posicaoAtualY, largura, altura);
  }
  
  void Colidir()
  {
    //Colidiu com algum dos jogadores
    for (int x = 0; x < j.length; x++)
    {
      if(Collider.IsRectColliding(posicaoAtualX, j[x].posicaoAtualX, posicaoAtualY, j[x].posicaoAtualY, largura, j[x].largura, altura, j[x].altura))
      { 
        if(posicaoAtualX < j[0].posicaoAtualX + j[0].largura)
          posicaoAtualX = j[0].posicaoAtualX + j[0].largura;
        
        if(posicaoAtualX > width - 35 - j[1].largura)
          posicaoAtualX = width - 35 - j[1].largura;
        
        if(g.audio)
          c.TocarSom(g.pingFX);
      
        //A tela está sendo dividida em 5 partes. 
        //Se estiver em alguma das duas partes de cima da dela
        if(Collider.IsRectColliding(posicaoAtualY, 0, 0, 0, (height / 5) * 2, 0))
        {
          //Se a colisão ocorrer na primeira parte de cima da tela
          if(Collider.IsRectColliding(posicaoAtualY, 0, 0, 0, height / 5, 0))
          {
            direcaoVertical = 1;
          
            //O jogador está sendo dividido em 5 partes.
            //Se colidir com a primeira parte do jogador
            if((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco, 0)))
              angulacao = random(1.35, 2);
            //Se colidir com a segunda parte do jogador
            else if((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco, 0, j[x].posicaoAtualY + j[x].alturaBloco * 2, 0)))
              angulacao = random(0.6, 1);
            //Se colidir com a terceira parte do jogador
            else if((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco * 2, 0, j[x].posicaoAtualY + j[x].alturaBloco * 3, 0)))
              angulacao = random(0.1, 0.35);
            //Se colidir com a quarta parte do jogador
            else if ((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco * 3, 0, j[x].posicaoAtualY + j[x].alturaBloco * 4, 0)))
              angulacao = random(0.6, 1);
            //Se colidir com a quinta parte do jogador
            else if ((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco * 4, 0, j[x].altura, 0)))
              angulacao = random(1.35, 2);
          }
          //Se a colisão ocorrer na segunda de cima parte da tela
          else
          {
            //O jogador está sendo dividido em 5 partes.
            //Se colidir com a primeira parte do jogador
            if((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco, 0)))
            {
              direcaoVertical = 1;
              angulacao = random(1.25, 1.85);
            }
            //Se colidir com a segunda parte do jogador
            else if((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco, 0, j[x].posicaoAtualY + j[x].alturaBloco * 2, 0)))
            {
              direcaoVertical = 1;
              angulacao = random(0.45, 0.85);
            }
            //Se colidir com a terceira parte do jogador
            else if((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco * 2, 0, j[x].posicaoAtualY + j[x].alturaBloco * 3, 0)))
            {
              direcaoVertical = random(-1, 1);
              angulacao = random(0.1, 0.35);
            }
            //Se colidir com a quarta parte do jogador
            else if ((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco * 3, 0, j[x].posicaoAtualY + j[x].alturaBloco * 4, 0)))
            {
              direcaoVertical = -1;
              angulacao = random(0.45, 0.85);
            }
            //Se colidir com a quinta parte do jogador
            else if ((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco * 4, 0, j[x].altura, 0)))
            {
              direcaoVertical = -1;
              angulacao = random(1.25, 1.85);
            }
          }
        }
        //Se estiver em alguma das duas partes de baixo da dela
        else if(Collider.IsRectColliding(posicaoAtualY, 0, (height / 5) * 3, 0 , height, 0))
        {
          //Se a colisão ocorrer na primeira parte de baixo da tela
          if(Collider.IsRectColliding(posicaoAtualY, 0, (height / 5) * 3, 0, (height / 5) * 4, 0)) 
          {
            //O jogador está sendo dividido em 5 partes.
            //Se colidir com a primeira parte do jogador
            if((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco, 0)))
            {
              direcaoVertical = -1;
              angulacao = random(1.25, 1.85);
            }
            //Se colidir com a segunda parte do jogador
            else if((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco, 0, j[x].posicaoAtualY + j[x].alturaBloco * 2, 0)))
            {
              direcaoVertical = -1;
              angulacao = random(0.45, 0.85);
            }
            //Se colidir com a terceira parte do jogador
            else if((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco * 2, 0, j[x].posicaoAtualY + j[x].alturaBloco * 3, 0)))
            {
              direcaoVertical = random(-1, 1);
              angulacao = random(0.1, 0.35);
            }
            //Se colidir com a quarta parte do jogador
            else if ((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco * 3, 0, j[x].posicaoAtualY + j[x].alturaBloco * 4, 0)))
            {
              direcaoVertical = 1;
              angulacao = random(0.45, 0.85);
            }
            //Se colidir com a quinta parte do jogador
            else if ((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco * 4, 0, j[x].altura, 0)))
            {
              direcaoVertical = 1;
              angulacao = random(1.25, 1.85);
            }
          }
          //Se a colisão ocorrer na segunda parte de baixo da tela
          else
          {
            direcaoVertical = -1;
          
            //O jogador está sendo dividido em 5 partes.
            //Se colidir com a primeira parte do jogador
            if((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco, 0)))
              angulacao = random(1.35, 2);
            //Se colidir com a segunda parte do jogador
            else if((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco, 0, j[x].posicaoAtualY + j[x].alturaBloco * 2, 0)))
              angulacao = random(0.6, 1);
            //Se colidir com a terceira parte do jogador
            else if((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco * 2, 0, j[x].posicaoAtualY + j[x].alturaBloco * 3, 0)))
              angulacao = random(0.1, 0.35);
            //Se colidir com a quarta parte do jogador
            else if ((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco * 3, 0, j[x].posicaoAtualY + j[x].alturaBloco * 4, 0)))
              angulacao = random(0.6, 1);
            //Se colidir com a quinta parte do jogador
            else if ((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco * 4, 0, j[x].altura, 0)))
              angulacao = random(1.35, 2);
          }
        }
        //Se estiver no meio da dela
        else
        {
            //O jogador está sendo dividido em 5 partes.
            //Se colidir com a primeira parte do jogador
            if((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco, 0)))
            {
              direcaoVertical = -1;
              angulacao = random(1.75, 2.25);
            }
            //Se colidir com a segunda parte do jogador
            else if((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco, 0, j[x].posicaoAtualY + j[x].alturaBloco * 2, 0)))
            {
              direcaoVertical = -1;
              angulacao = random(1, 1.5);
            }
            //Se colidir com a terceira parte do jogador
            else if((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco * 2, 0, j[x].posicaoAtualY + j[0].alturaBloco * 3, 0)))
            {
              direcaoVertical = random(-1, 1);
              angulacao = random(0.25, 1);
            }
            //Se colidir com a quarta parte do jogador
            else if ((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco * 3, 0, j[x].posicaoAtualY + j[0].alturaBloco * 4, 0)))
            {
              direcaoVertical = 1;
              angulacao = random(1, 1.5);
            }
            //Se colidir com a quinta parte do jogador
            else if ((Collider.IsRectColliding(posicaoAtualY, 0, j[x].posicaoAtualY + j[x].alturaBloco * 4, 0, j[x].altura, 0)))
            {
              direcaoVertical = 1;
              angulacao = random(1.75, 2.25);
            }
          }
        
          direcaoHorizontal = -direcaoHorizontal;
        }
      }
    
    if(posicaoAtualY <= 0 || posicaoAtualY >= height)
      direcaoVertical = -direcaoVertical;
    
    if(posicaoAtualX >= width)
    {
      posicaoAtualX = width / 2 - largura / 2;
      posicaoAtualY = height / 2 - altura / 2;
      
      direcaoHorizontal = 1;
      angulacao = 1;
      g.pontosj1 += 1;

      g.contador = 0;
    }
    else if(posicaoAtualX <= 0)
    {
      posicaoAtualX = width / 2 - largura / 2;
      posicaoAtualY = height / 2 - altura / 2;
     
      direcaoHorizontal = -1;
      angulacao = 1;
      g.pontosj2 += 1;
      
      g.contador = 0;
    }
  }
}

class CommonControls
{  
  void TocarSom(SoundFile som)
  {
    som.stop();
    som.play();
  }
}
