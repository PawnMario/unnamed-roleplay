stock LoadMaterial(limit[] = "", bool:return_id = false, serverstart = 0)
{
	new rows, Cache:tmp_cache, count;
	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM ipb_materials %s", limit));  
	cache_get_row_count(rows);
	new mid, owner;
	
	for(new row = 0; row != rows; row++)
	{
		mid++;
		
		cache_get_value_index_int(row, 2, owner);

		new uid = owner;

		new trans[100];
		cache_get_value_index(row, 1, trans);

		new oid = GetObjectByUid(uid);
		if(oid == -1) 
		{
			continue;
		}

		if(serverstart && Object[oid][object_vw] != 0) continue;

		count++;

		new type, data[100];
		if( !sscanf(trans, "p<^>ds[100]", type, data) )
		{
			switch(type)
			{
				case 0:
				{
					new index, color[16], mmodel, txd_name[32], texture_name[32];
					sscanf(data, "p<:>ds[16]ds[32]s[32]", index, color, mmodel, txd_name, texture_name);
					format(color, 16, "0x%s", color);

					if( !strcmp(color, "0x000000") ) SetDynamicObjectMaterial(oid, index, mmodel, txd_name, texture_name, 0);
					else SetDynamicObjectMaterial(oid, index, mmodel, txd_name, texture_name, HexToInt(color));
				}
				
				case 1:
				{
					new index, msize, fsize, bold, fcolor[16], bcolor[16], align, font[32], text[100];
					sscanf(data, "p<:>dddds[16]s[16]ds[32] s[50]", index, msize, fsize, bold, fcolor, bcolor, align, font, text);
					format(fcolor, 16, "0x%s", fcolor);
					
					if( strcmp(bcolor, "000000") != 0 ) format(bcolor, 16, "0x%s", bcolor);
					
					for(new y=0;y<text[y];y++)
					{
						if(text[y] == '|')
						{
							strdel(text, y, y+1);
							strins(text, "\n", y);
						}
					}
					
					strreplace(text, '(', '{');
					strreplace(text, ')', '}');
					
					if( strcmp(bcolor, "000000") != 0 ) SetDynamicObjectMaterialText(oid, index, text, msize, font, fsize, bold, HexToInt(fcolor), HexToInt(bcolor), align);
					else SetDynamicObjectMaterialText(oid, index, text, msize, font, fsize, bold, HexToInt(fcolor), 0, align);
				}
			}
		}
	}
	
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	if( return_id ) return mid;
	return count;
}