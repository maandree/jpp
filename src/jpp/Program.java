/**
 * jpp — Bash based preprocessor for Java
 * 
 * Copyright © 2012  Mattias Andrée (maandree+jpp@kth.se)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package jpp;

import java.util.*;


/**
 * This is the mane class
 * 
 * @author  Mattias Andrée, <a href="mailto:maandree+jpp@kth.se">maandree+jpp@kth.se</a>
 */
public class Program
{
    /**
     * This is the mane entry point of the program
     * 
     * @param  args  Command line arguments
     */
    public static void main(final String... args)
    {
	String linger = null;
	boolean dashed = false;
	
	final ArrayList<String> files = new ArrayList<String>();
	final HashSet<String> fileSet = new HashSet<String>();
	String oFlag = null;
	
	for (final String arg : args)
	    if (linger == null)
		if (dashed || ((arg.startsWith("-") || arg.startsWith("+")) == false))
		{   if (fileSet.contains(arg))
		    {   err(1, "fatal", arg, "0", "File does not exist");
			System.exit(-1); return;
		    }
		    files.add(arg);
		    fileSet(arg);
		}
		else if (args.equals("--"))
		    dashed = true;
		else
		    linger = arg;
	    else
	    {   if (linger.equals("-o") || linger.equals("--out") || linger.equals("--output"))
		    if (oFlag == null)
			oFlag = arg;
		    else
		    {   err(1, "fatal", null, null, "Duplicate option: -o");
			System.exit(-1); return;
		    }
		else
		    err(3, "warning", null, null, "Unrecognised option: " + linger);
		
		linger = null;
	    }
	
	if ((linger != null) || (oFlag  == null))
	{
	    if (linger != null)  err(1, "fatal", null, null, "Lingering flag argument: " + linger);
	    if (oFlag  == null)  err(1, "fatal", null, null, "Unspecified option: -o");
	    System.exit(-1); return;
	}
	
	try
	{   if ((new File(oFlag)).exists() == false)
		(new File(oFlag)).mkdirs();
	    else if ((new File(oFlag)).isDirectory() == false)
	    {   err(1, "fatal", null, null, oFlag + " exists but is not a directory");
		System.exit(-1); return;
	}   }
	catch (final Throwable err)
	{   err(1, "error", null, null, err.toString());
	    System.exit(-2); return;
	}
	
	try
        {   for (final String file : files)
	    {
		String _file = file;
		if (_file.toLowerCase().endsWith(".jpp"))
		    _file = _file.substring(0, _file.length() - 4) + ".java";
		process(file, (new File(oFlag, _file)).getAbsolutePath()); /* Do *NOT* use canonical path */
	    }
	}
	catch (final Throwable err)
	{   err(1, "error", null, null, err.toString());
	    System.exit(-2); return;
	}
    }
    
    
    /**
     * Prints and error message to stderr
     * 
     * @param  colour       ANSI colour index of error type
     * @param  type         Error type
     * @param  file         The file where the error occoured, may be {@code null}
     * @param  location     The location in the file where the error occoured, may be {@code null}
     * @param  description  The error description
     */
    static void err(final int colour, final String type, final String file, final String location, final String description)
    {
	final String _type        = type        == null ? null : location   .replace("\033", "\033[2m\\033\033[22m");
	final String _file        = file        == null ? null : file       .replace("\033", "\033[2m\\033\033[22m");
	final String _location    = location    == null ? null : location   .replace("\033", "\033[2m\\033\033[22m");
	final String _description = description == null ? null : description.replace("\033", "\033[2m\\033\033[22m");
	final String ucs = "\033[0;1;3" + colour + "mjpp\033[37m:\033[3" + colour + "m" + _type + "\033[37m:\033[21m"
	                 + (_file == null ? "" : "\033[35m" + _file + "\033[37m:")
	                 + (_location == null ? "" : "\033[32m" + _location.replace(":", "\033[37m:\033[32m") + "\033[37m:")
	                 + _description.replace(":", "\033[37m:\033[34m") + "\033[0m";
	final StringBuilder ascii = new StringBuilder();
	for (final byte b : usc.getBytes("UTF-8"))
	    if ((((b & 128) == 0) && (' ' <= b)) || (b == '\033'))
		ascii.append((char)b);
	    else
	    {   byte o = b;
		ascii.append("\033[2m\\0");
		while (o != 0)
		{   ascii.append((char)('0' | (o & 7)));
		    o >>>= 3;
		}
		ascii.append("\033[22m");
	    }
	System.err.println(ascii.toString());
    }
    
    
    /**
     * Processes a <tt>jpp</tt> file
     * 
     * @param  input   Input <tt>jpp</tt> file
     * @param  output  Output <tt>java</tt> file
     * 
     * @throws  Throwable  In case something is wrong
     */
    public static void process(final String input, final String output) throws Throwable
    {
    }
    
}

