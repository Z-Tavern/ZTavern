main()
{
	replaceFunc( codescripts\struct::createstruct, ::customcreatestruct );
}

init ()
{
   // level thread printstruct();
}

customcreatestruct()
{
    struct = spawnstruct();
 //   iPrintLn("contact ^1Admin^7");
    level.struct[level.struct.size] = struct;
    return struct;
}

printstruct()
{
    for (;;)
    {
        iPrintln("struct count = " + level.struct.size);
       /* for(i = 0; i < level.struct.size; i++)
        {
            iPrintLn("struct +1");
            iPrintLn(level.struct[i]);
        }*/
        wait 10;
    }
}