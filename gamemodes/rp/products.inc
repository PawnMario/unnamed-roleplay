stock LoadProducts()
{
	Code_ExTimer_Begin(LoadProducts);

	new day= GetDayName();
    if(day == 7)
    {
    	printf("[SARP] Wykonano cotygodniowy reset limitu zamawiania produktow.");
    	mysql_query(mySQLconnection, "UPDATE ipb_products SET product_limit_used = 0");
    }

	new rows, Cache:tmp_cache, p_id;

	tmp_cache = mysql_query(mySQLconnection, "SELECT * FROM `ipb_products`");
	cache_get_row_count(rows);

	for(new row = 0; row != rows; row++)
	{
		p_id++;

		cache_get_value_index_int(row, 0, Product[p_id][product_id]);
		cache_get_value_index(row, 1, Product[p_id][product_name], 40);
		cache_get_value_index_int(row, 2, Product[p_id][product_type]);
		cache_get_value_index_int(row, 3, Product[p_id][product_owner]);
		cache_get_value_index_int(row, 4, Product[p_id][product_price]);
		cache_get_value_index_int(row, 5, Product[p_id][product_value1]);
		cache_get_value_index_int(row, 6, Product[p_id][product_value2]);
		cache_get_value_index_int(row, 7, Product[p_id][product_model]);
		cache_get_value_index_int(row, 8, Product[p_id][product_extra]);
		cache_get_value_index_int(row, 9, Product[p_id][product_group]);
		cache_get_value_index_int(row, 10, Product[p_id][product_limit]);
		cache_get_value_index_int(row, 11, Product[p_id][product_limit_used]);
		cache_get_value_index_int(row, 12, Product[p_id][product_player]);

		Iter_Add(Products, p_id);
	}

	printf("Wczytano produkty [wczytanych: %d] [czas %d ms]", p_id, Code_ExTimer_End(LoadProducts));
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	return 1;
}

stock ReloadBonusProducts(gid, product_ids[])
{
	Code_ExTimer_Begin(ReloadBonusProducts);

	new rows, Cache:tmp_cache, p_id, in_str[64];

	for(new i=0;i<10;i++)
	{
		format(in_str, sizeof(in_str), "%d,%s", product_ids[i], in_str);
	}

	new last_mark = sizeof(in_str)-2;

	if(strfind(in_str, ",", false, last_mark)) strdel(in_str, sizeof(in_str)-2, sizeof(in_str)-2);

	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM `ipb_products` WHERE product_uid IN (%s)", in_str));
	cache_get_row_count(rows);

	for(new row = 0; row != rows; row++)
	{
		p_id++;

		cache_get_value_index_int(row, 0, Product[p_id][product_id]);
		cache_get_value_index(row, 1, Product[p_id][product_name], 40);
		cache_get_value_index_int(row, 2, Product[p_id][product_type]);
		cache_get_value_index_int(row, 3, Product[p_id][product_owner]);
		cache_get_value_index_int(row, 4, Product[p_id][product_price]);
		cache_get_value_index_int(row, 5, Product[p_id][product_value1]);
		cache_get_value_index_int(row, 6, Product[p_id][product_value2]);
		cache_get_value_index_int(row, 7, Product[p_id][product_model]);
		cache_get_value_index_int(row, 8, Product[p_id][product_extra]);
		cache_get_value_index_int(row, 9, Product[p_id][product_group]);
		cache_get_value_index_int(row, 10, Product[p_id][product_limit]);
		cache_get_value_index_int(row, 11, Product[p_id][product_limit_used]);
		cache_get_value_index_int(row, 12, Product[p_id][product_player]);

		Iter_Add(Products, p_id);
	}

	printf("Zaladowano bonusowe produkty grupy %d [wczytanych: %d] [czas %d ms]", Group[gid][group_uid], p_id, Code_ExTimer_End(ReloadBonusProducts));
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	return 1;
}

stock AddBonusProduct(gid)
{
	new str[300];
	Group[gid][group_level]++;
	mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_game_groups SET group_level = %d WHERE group_uid = %d", Group[gid][group_level], Group[gid][group_uid]));
	switch(Group[gid][group_level])
	{
		case 1:
		{
			new loaded_ids[10];

			// Extasy nowy limit, 200g
			format(str, sizeof(str), "UPDATE ipb_products SET product_limit_count = 200 WHERE product_name = 'MDMA' AND product_group = %d AND product_value1 = 7", Group[gid][group_uid]);
			mysql_query(mySQLconnection, str);
			loaded_ids[0] = cache_insert_id();

			// Losujemy bron, deagle lub tec9 lub uzi
			new wrand = random(3);

			switch(wrand)
			{
				case 0:
				{
					format(str, sizeof(str), "");
					strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_value1, product_value2, product_model, product_group, product_limit_count) ");
					strcat(str, sprintf("VALUES (%d, 'Tec9', 1650, 32, 60, 372, %d, 10)", ITEM_TYPE_WEAPON, Group[gid][group_uid]));
					mysql_query(mySQLconnection, str);
					loaded_ids[1] = cache_insert_id();
				}
				case 1:
				{
					format(str, sizeof(str), "");
					strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_value1, product_value2, product_model, product_group, product_limit_count) ");
					strcat(str, sprintf("VALUES (%d, 'Micro Uzi', 1800, 28, 60, 352, %d, 10)", ITEM_TYPE_WEAPON, Group[gid][group_uid]));
					mysql_query(mySQLconnection, str);
					loaded_ids[1] = cache_insert_id();
				}
				case 2:
				{
					format(str, sizeof(str), "");
					strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_value1, product_value2, product_model, product_group, product_limit_count) ");
					strcat(str, sprintf("VALUES (%d, 'Desert Eagle', 1200, 24, 45, 348, %d, 10)", ITEM_TYPE_WEAPON, Group[gid][group_uid]));
					mysql_query(mySQLconnection, str);
					loaded_ids[1] = cache_insert_id();
				}
			}

			// Przedmiot do demolki lokalu
			format(str, sizeof(str), "");
			strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_model, product_group, product_limit_count) ");
			strcat(str, sprintf("VALUES (%d, 'Zestaw do demolki', 4800, 336, %d, 1)", ITEM_TYPE_DEMOLITION, Group[gid][group_uid]));
			mysql_query(mySQLconnection, str);
			loaded_ids[2] = cache_insert_id();

			//elektronika do sejfow
			format(str, sizeof(str), "");
			strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_model, product_group, product_limit_count, product_value1) ");
			strcat(str, sprintf("VALUES (%d, 'Elektronika', 1800, 18875, %d, 1, 1)", ITEM_TYPE_ROB_BOMBEL, Group[gid][group_uid]));
			mysql_query(mySQLconnection, str);
			loaded_ids[3] = cache_insert_id();

			ReloadBonusProducts(gid, loaded_ids);
		}
		case 2:
		{
			new loaded_ids[10];
			new wrand = random(2);
			switch(wrand)
			{
				//Hash 150g
				case 0:
				{
					format(str, sizeof(str), "");
					strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_value1, product_value2, product_model, product_group, product_limit_count) ");
					strcat(str, sprintf("VALUES (%d, 'Hash', 50, 8, 1, 1575, %d, 150)", ITEM_TYPE_DRUG, Group[gid][group_uid]));
					mysql_query(mySQLconnection, str);
					loaded_ids[0] = cache_insert_id();
				}
				//Dodatkowa amunicja
				case 1:
				{
					new prod_id;

					foreach(new p_id: Products)
					{
						if(Product[p_id][product_group] == Group[gid][group_uid] && Product[p_id][product_type] == ITEM_TYPE_AMMO && Product[p_id][product_value1] == 2) prod_id = p_id;
					}

					if(prod_id != 0)
					{
						mysql_query(mySQLconnection, sprintf("UPDATE ipb_products SET product_limit_count = 30 WHERE product_uid = %d", Product[prod_id][product_id]));
						ReloadProduct(Product[prod_id][product_id]);
					}
				}
			}

			//todo dodac tu trucizne 7 dniowa

			ReloadBonusProducts(gid, loaded_ids);
		}
		case 4:
		{	
			new loaded_ids[10];

			// Losujemy shotguna lub mp5
			new wrand = random(2);
			switch(wrand)
			{
				case 0:
				{
					format(str, sizeof(str), "");
					strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_value1, product_value2, product_model, product_group, product_limit_count) ");
					strcat(str, sprintf("VALUES (%d, 'Shotgun', 2200, 25, 30, 349, %d, 10)", ITEM_TYPE_WEAPON, Group[gid][group_uid]));
					mysql_query(mySQLconnection, str);
					loaded_ids[0] = cache_insert_id();
				}
				case 1:
				{
					format(str, sizeof(str), "");
					strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_value1, product_value2, product_model, product_group, product_limit_count) ");
					strcat(str, sprintf("VALUES (%d, 'MP5', 2800, 29, 70, 353, %d, 10)", ITEM_TYPE_WEAPON, Group[gid][group_uid]));
					mysql_query(mySQLconnection, str);
					loaded_ids[0] = cache_insert_id();
				}
			}

			//todo dodac tu trucizne 14 dni

			//bomba do napadow
			format(str, sizeof(str), "");
			strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_model, product_group, product_limit_count, product_value1) ");
			strcat(str, sprintf("VALUES (%d, 'Materialy wybuchowe', 1800, 18875, %d, 2, 2)", ITEM_TYPE_ROB_BOMBEL, Group[gid][group_uid]));
			mysql_query(mySQLconnection, str);
			loaded_ids[1] = cache_insert_id();

			ReloadBonusProducts(gid, loaded_ids);
		}
		case 5:
		{
			new loaded_ids[10];
			//todo dodac tu trucizne permanentna 

			//20 sztuk amunicja bron dluga lub 10x AK47
			new wrand = random(2);
			switch(wrand)
			{
				case 0:
				{
					format(str, sizeof(str), "");
					strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_value1, product_value2, product_model, product_group, product_limit_count) ");
					strcat(str, sprintf("VALUES (%d, 'Amunicja (bron dluga)', 520, 3, 40, 19995, %d, 20)", ITEM_TYPE_AMMO, Group[gid][group_uid]));
					mysql_query(mySQLconnection, str);
					loaded_ids[0] = cache_insert_id();
				}
				case 1:
				{
					format(str, sizeof(str), "");
					strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_value1, product_value2, product_model, product_group, product_limit_count) ");
					strcat(str, sprintf("VALUES (%d, 'AK47', 4500, 30, 70, 355, %d, 10)", ITEM_TYPE_WEAPON, Group[gid][group_uid]));
					mysql_query(mySQLconnection, str);
					loaded_ids[0] = cache_insert_id();
				}
			}
			ReloadBonusProducts(gid, loaded_ids);
		}
		default:
		{	
			new wrand = random(2);

			switch(wrand)
			{
				// Zwiekszenie ilosci magazynkow o 10
				case 0:
				{
					new prod_id;

					foreach(new p_id: Products)
					{
						if(Product[p_id][product_group] == Group[gid][group_uid] && Product[p_id][product_type] == ITEM_TYPE_AMMO && Product[p_id][product_value1] == 3) prod_id = p_id;
					}

					if(prod_id != 0)
					{
						mysql_query(mySQLconnection, sprintf("UPDATE ipb_products SET product_limit_count = product_limit_count + 10 WHERE product_uid = %d", Product[prod_id][product_id]));
						ReloadProduct(Product[prod_id][product_id]);
					}
				}
				// Zwiekszenie ilosci narkotykow o 50g
				case 1:
				{
					new prod_id;

					foreach(new p_id: Products)
					{
						if(Product[p_id][product_group] == Group[gid][group_uid] && Product[p_id][product_type] == ITEM_TYPE_DRUG) prod_id = p_id;
					}

					if(prod_id != 0)
					{
						mysql_query(mySQLconnection, sprintf("UPDATE ipb_products SET product_limit_count = product_limit_count + 50 WHERE product_uid = %d", Product[prod_id][product_id]));
						ReloadProduct(Product[prod_id][product_id]);
					}
				}
			}
		}
	}
}

stock RemoveBonusProduct(gid)
{
	mysql_query(mySQLconnection, sprintf("DELETE FROM ipb_products WHERE product_group = %d ORDER BY product_uid DESC LIMIT 1", Group[gid][group_uid]));
}

stock LoadProduct(prod_uid)
{
	new p_id = Iter_Free(Products), Cache:tmp_cache;

	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM `ipb_products` WHERE product_uid = %d LIMIT 1", prod_uid));

	if(cache_num_rows())
	{
		cache_get_value_index_int(0, 0, Product[p_id][product_id]);
		cache_get_value_index(0, 1, Product[p_id][product_name], 40);
		cache_get_value_index_int(0, 2, Product[p_id][product_type]);
		cache_get_value_index_int(0, 3, Product[p_id][product_owner]);
		cache_get_value_index_int(0, 4, Product[p_id][product_price]);
		cache_get_value_index_int(0, 5, Product[p_id][product_value1]);
		cache_get_value_index_int(0, 6, Product[p_id][product_value2]);
		cache_get_value_index_int(0, 7, Product[p_id][product_model]);
		cache_get_value_index_int(0, 8, Product[p_id][product_extra]);
		cache_get_value_index_int(0, 9, Product[p_id][product_group]);
		cache_get_value_index_int(0, 10, Product[p_id][product_limit]);
		cache_get_value_index_int(0, 11, Product[p_id][product_limit_used]);
		cache_get_value_index_int(0, 12, Product[p_id][product_player]);
	}
	Iter_Add(Products, p_id);
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	return p_id;
}

stock ReloadProduct(prod_uid)
{
	new prod_id = GetProductByUid(prod_uid);
	if(prod_id == -1) return 1;

	Product[prod_id][product_id] = 0;
	Product[prod_id][product_type] = 0;
	Product[prod_id][product_owner] = 0;
	Product[prod_id][product_price] = 0; 
	Product[prod_id][product_value1] = 0; 
	Product[prod_id][product_value2] = 0;   
	Product[prod_id][product_model] = 0;  
	Product[prod_id][product_extra] = 0;
	Product[prod_id][product_group] = 0;
	Product[prod_id][product_player] = 0;

	Iter_Remove(Products, prod_id);

	new p_id = Iter_Free(Products);
	new Cache:tmp_cache;

	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM `ipb_products` WHERE product_uid = %d LIMIT 1", prod_uid));

	cache_get_value_index_int(0, 0, Product[p_id][product_id]);
	cache_get_value_index(0, 1, Product[p_id][product_name], 40);
	cache_get_value_index_int(0, 2, Product[p_id][product_type]);
	cache_get_value_index_int(0, 3, Product[p_id][product_owner]);
	cache_get_value_index_int(0, 4, Product[p_id][product_price]);
	cache_get_value_index_int(0, 5, Product[p_id][product_value1]);
	cache_get_value_index_int(0, 6, Product[p_id][product_value2]);
	cache_get_value_index_int(0, 7, Product[p_id][product_model]);
	cache_get_value_index_int(0, 8, Product[p_id][product_extra]);
	cache_get_value_index_int(0, 9, Product[p_id][product_group]);
	cache_get_value_index_int(0, 10, Product[p_id][product_limit]);
	cache_get_value_index_int(0, 11, Product[p_id][product_limit_used]);
	cache_get_value_index_int(0, 12, Product[p_id][product_player]);

	Iter_Add(Products, p_id);

	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	return p_id;
}

stock GetProductByUid(prodUid)
{
	foreach (new p : Products)
	{
		if( Product[p][product_id] == prodUid ) return p;
	}
	
	return -1;
}

stock RemoveProduct(prod_uid)
{
	new prod_id = GetProductByUid(prod_uid);
	if(prod_id == -1) return 1;

	Product[prod_id][product_id] = 0;
	Product[prod_id][product_type] = 0;
	Product[prod_id][product_owner] = 0;
	Product[prod_id][product_price] = 0; 
	Product[prod_id][product_value1] = 0; 
	Product[prod_id][product_value2] = 0;   
	Product[prod_id][product_model] = 0;  
	Product[prod_id][product_extra] = 0;
	Product[prod_id][product_group] = 0;
	Product[prod_id][product_player] = 0;

	Iter_Remove(Products, prod_id);
	
	return 1;
}