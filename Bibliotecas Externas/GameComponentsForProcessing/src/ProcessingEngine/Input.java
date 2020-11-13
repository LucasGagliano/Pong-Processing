package ProcessingEngine;
import java.awt.Color;
import java.awt.MouseInfo;
import java.awt.Graphics;

public class Input 
{
	int inputValue = 0;
	  
	public int GetAxis(String Axis, boolean teclaPositiva, boolean teclaNegativa)
	{
	  switch(Axis)
	  {
	     case "Vertical":
	       if(teclaPositiva || teclaNegativa)
	       {
	         if(teclaPositiva)
	           inputValue = -1;
	         else
	           inputValue =  1;
	       }
	       else
	         inputValue = 0;
	     break;
	     
	     case "Horizontal":
		       if(teclaPositiva || teclaNegativa)
		       {
		         if(teclaPositiva)
		           inputValue = -1;
		         else
		           inputValue =  1;
		       }
		       else
		         inputValue = 0;
	  }
	  return inputValue;
	}
}
	


