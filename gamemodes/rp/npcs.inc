stock GetNPCByArea(areaid)
{
	foreach(new npcid: NPCs)
	{
		if(NPC[npcid][npc_area] == areaid) return npcid;
	}

	return -1;
}

stock GetFreeNPCID()
{
	for (new npcslot; npcslot < MAX_NPCS; npcslot++) 
	{
		if (!IsPlayerConnected(npcslot)) 
		{
			return npcslot;
		}
	}
	return -1;
}