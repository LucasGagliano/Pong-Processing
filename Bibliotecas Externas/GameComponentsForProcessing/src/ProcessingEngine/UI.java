package ProcessingEngine;
import processing.core.*;



public class UI extends PApplet
{
	float posicaoXBola = 0;

	//Criação base de um botão
	public boolean CriarBotoes(PApplet processingSketch, char tipoBotao, PImage icone, float posicaoX, float posicaoY, float largura, float altura, String textoBotao, int tamanhoFonte)
	{
		boolean retorno = false;

		switch (tipoBotao)
		{
			case 'i':
				processingSketch.image(icone, posicaoX, posicaoY, largura, altura);

				if(processingSketch.mouseX >= posicaoX && processingSketch.mouseX <= posicaoX + largura && processingSketch.mouseY >= posicaoY && processingSketch.mouseY <= posicaoY + altura)
					retorno = true;
				else
					retorno = false;
				break;

			case 't':
				processingSketch.textSize(tamanhoFonte);
				if(processingSketch.mouseX >= posicaoX && processingSketch.mouseX <= posicaoX + processingSketch.textWidth(textoBotao) && processingSketch.mouseY >= posicaoY - 50 && processingSketch.mouseY <= posicaoY + processingSketch.textAscent() - 92.5)
				{
					processingSketch.fill(255, 55, 55);
					retorno = true;
				}
				else
				{
					processingSketch.fill(255);
					retorno = false;
				}

				processingSketch.text(textoBotao, posicaoX, posicaoY);
				break;

		}
		return retorno;
	}

	//Se o botão for um texto
	public boolean CriarBotoes(PApplet processingSketch, char tipoBotao, float posicaoX, float posicaoY, String textoBotao, int tamanhoFonte)
	{
		return CriarBotoes(processingSketch, tipoBotao, null, posicaoX, posicaoY, 0, 0, textoBotao, tamanhoFonte);
	}

	//Se o botão for uma imagem 
	public boolean CriarBotoes(PApplet processingSketch, char tipoBotao, PImage icone, float posicaoX, float posicaoY, float largura, float altura)
	{
		return CriarBotoes(processingSketch, tipoBotao, icone, posicaoX, posicaoY, largura, altura, null, 0);
	}

	//Criação base de um slider
	public float CriarSlider(PApplet processingSketch, float posicaoX, float posicaoY, float largura)
	{
		float valorSlider = 0;

		if(posicaoXBola == 0)
			posicaoXBola = posicaoX + 15;

		processingSketch.rect(posicaoX, posicaoY, largura, 10);

		if((processingSketch.mouseX >= posicaoX && processingSketch.mouseX <= posicaoX + largura && processingSketch.mouseY >= posicaoY && processingSketch.mouseY <= posicaoY + 20) && processingSketch.mousePressed)
		{
			processingSketch.fill(255, 0, 0);
			posicaoXBola = processingSketch.mouseX;
		}
		else
			processingSketch.fill(255);

		valorSlider = posicaoXBola - posicaoX;

		processingSketch.stroke(0);
		processingSketch.ellipse(posicaoXBola, posicaoY + 7, 15, 15);

		return valorSlider;
	}
}