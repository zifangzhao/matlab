%% map for Blackrock 16 tetrode
init_ch=bsxfun(@plus,[0,1]',0:8:15);
init_ch=init_ch(:);
ch=arrayfun(@(x) [x:2:x+6]',init_ch,'uni',0);
map=Klusta_MapGen_Ntrode(ch);
Klusta_PRBgen('Blackrock_tetrode_16ch.prb',map.connection,map.map);

%% map for Blackrock 32 tetrode
init_ch=bsxfun(@plus,[0,1]',0:8:31);
init_ch=init_ch(:);
ch=arrayfun(@(x) [x:2:x+6]',init_ch,'uni',0);
map=Klusta_MapGen_Ntrode(ch);
Klusta_PRBgen('Blackrock_tetrode_32ch.prb',map.connection,map.map);

%% map for Intan 32 tetrode
init_ch=bsxfun(@plus,0',0:4:31);
init_ch=init_ch(:);
ch=arrayfun(@(x) [x:1:x+3]',init_ch,'uni',0);
map=Klusta_MapGen_Ntrode(ch);
Klusta_PRBgen('Intan_tetrode_32ch.prb',map.connection,map.map);

%% map for DBC P32-5
ch={([16 12 8 6 2 3 5 9 11 7 1 4 13 14 10 15 17 21 22 25 27 29 28 30 32 31 26 24 20 19 23 18]-1)'};
map=Klusta_MapGen(ch);
Klusta_PRBgen('DBC_32-5.prb',map.connection,map.map);