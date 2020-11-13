package ProcessingEngine;

public class Collider
{	
	boolean isColliding;
	
	public boolean IsRectColliding(float x1, float x2, float y1, float y2, float largura1, float largura2, float altura1, float altura2)
	{
		if ((x2 <= x1 + largura1 && x2 >= x1 || x1 <= x2 + largura2 && x1 >= x2) && (y2 <= y1 + altura1 && y2 >= y1 || y1 <= y2 + altura2 && y1 >= y2))
		{
			isColliding = true;
			return isColliding;
		}
		else
		{
			isColliding = false;
			return isColliding;
		}
	}
	public boolean IsRectColliding(float y1, float x1, float altura1, float largura1, float altura2, float largura2)
	{
		if ((y1 >= altura1 && y1 <= altura2) && (x1 >= largura1 && x1 <= largura2))
		{
			isColliding = true;
			return isColliding; 
		}
		else
		{
			isColliding = false;
			return isColliding;
		}
	}
}