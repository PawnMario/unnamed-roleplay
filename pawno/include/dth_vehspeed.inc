/**********************************
 *                                *
 *   @Author:      Dutheil        *
 *   @Version:     0.3		      *
 *   @Released:    18/08/2015     *
 *                                *
 **********************************/

#if defined _dth_speed_included
	#endinput
#endif	
#define _dth_speed_included

//-----------------------------
//-------------------------------------------------
//-----------------------------

/*
	native ConvertKmhToMph(const kmh);
	native ConvertMphToKmh(const mph);

	native GetVehicleSpeed(const vehicleid, const dth_speed_unit:unit=kmh);
	native SetVehicleSpeed(const vehicleid, speed, const dth_speed_unit:unit=kmh);
	
	native GetSpeedByMilliseconds(const speed, const milliseconds);
	
	native GetVehicleModelTopSpeed(const modelid);
*/

//-----------------------------
//-------------------------------------------------
//-----------------------------

#define ConvertKmhToMph(%0) floatround(float(%0)/1.609344)
#define ConvertMphToKmh(%0) floatround(float(%0)*1.609344)

//-----------------------------

#define KM_PER_MILLISECOND (0.00000028)

//-----------------------------

#define GetSpeedByMilliseconds(%0,%1) floatmul(float(%0), floatmul(float(%1), KM_PER_MILLISECOND))

//-----------------------------
//-------------------------------------------------
//-----------------------------

enum dth_speed_unit
{
	kmh,
	mph
}

//-----------------------------
//-------------------------------------------------
//-----------------------------

stock SetVehicleSpeed(const vehicleid, speed, const dth_speed_unit:unit=kmh)
{
	if(unit) speed = ConvertMphToKmh(speed);

	new
		Float:vel[3];
		
	GetVehicleVelocity(vehicleid, vel[0], vel[1], vel[2]);

	if(vel[0] == 0.0 && vel[1] == 0.0 && vel[2] == 0.0) return 0;
	
	new
		actualspeed = GetVehicleSpeed(vehicleid, kmh),
		Float:multiple = (speed + float(actualspeed) / 100) / (float(actualspeed) / 100) / 113.8333335;
	
	return SetVehicleVelocity(vehicleid, vel[0] * multiple, vel[1] * multiple, vel[2] * multiple);
}

//-----------------------------

stock GetVehicleSpeed(const vehicleid, const dth_speed_unit:unit=kmh) 
{
	static
		Float:vel[3];
		
	GetVehicleVelocity(vehicleid, vel[0], vel[1], vel[2]);
	
	if(vel[0] == 0.0 && vel[1] == 0.0 && vel[2] == 0.0) return 0;
	
	new
		speed = floatround(floatsqroot(vel[0] * vel[0] + vel[1] * vel[1] + vel[2] * vel[2]) * 187.666667);
	
	return (unit ? ConvertKmhToMph(speed) : speed);
}

//-----------------------------

stock GetVehicleModelTopSpeed(const modelid)
{
	static const
		maxspeed[] =
					{
						164, 153, 194, 115, 139, 171, 115, 154, 104, 165, 135, 231, 175, 115, 110, 200, 160, 281, 120, 155, 151, 160, 146, 103, 141, 281, 180, 172, 164, 209, 198, 136, 98, 115, 174, 0, 155,
						165, 148, 175, 142, 151, 145, 131, 115, 171, 281, 281, 116, 0, 0, 201, 281, 63, 141, 164, 111, 99, 164, 142, 281, 167, 116, 148, 151, 151, 153, 146, 150, 281, 164, 115, 198, 198, 155,
						180, 281, 194, 122, 146, 192, 76, 163, 127, 198, 103, 67, 281, 281, 145, 164, 155, 146, 281, 223, 183, 169, 281, 113, 128, 146, 151, 225, 225, 180, 146, 186, 173, 113, 83, 105, 281, 
						281, 281, 125, 148, 164, 164, 171, 281, 281, 167, 183, 157, 136, 167, 165, 155, 183, 155, 63, 73, 115, 174, 175, 165, 180, 0, 0, 281, 155, 211, 171, 157, 156, 153, 155, 148, 281, 159,
						151, 164, 126, 281, 150, 165, 118, 118, 163, 185, 176, 160, 185, 281, 151, 172, 167, 180, 152, 0, 0, 97, 63, 115, 63, 165, 165, 281, 136, 165, 159, 157, 142, 89, 0, 159, 148, 172, 113,
						169, 0, 0, 281, 281, 136, 198, 182, 182, 182, 165, 157, 115, 176, 178, 154, 158, 0, 0, 0, 113, 0, 0
					};
					
	return (400 <= modelid <= 611 ? maxspeed[modelid-400] : 0);
}