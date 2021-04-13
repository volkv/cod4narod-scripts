// Write a single string or an array of strings to file,
// if file already exists it will overwrite it.
// Returns FALSE on failure, TRUE on success
// File will close after writing.

getCvarTop(var) {
	
file = readFile( "top.db" );
if ( isArray(file) ){ 
	for( i = 0; i < file.size; i++ ){
		asset = strTok(file[i],"");
		
if (asset[0] == var) {

	return asset[1];
}
	
			}
	}
	
	return "";
	

}

setCvarTop(var, value) {

changed = false;	

file = readFile( "top.db" );

if ( isArray(file) ) {
	for( i = 0; i < file.size; i++ ){
		asset[i] = strTok(file[i],"");
		
if (asset[i][0] == var) {

	file[i] = var + "" + value;
	changed = true;
	
		}
	}
} 

if (changed == true) {
	writeToFile("top.db",file);
} else {

	appendToFile("top.db", var + "" + value);
	}
			
}

appendToFile( path, w )
{
	file = FS_FOpen( path, "append" );
	
	if( !isDefined( file ) )
		return false;
		
	if( isArray( w ) )
		writeArray( file, w );
	else
		FS_WriteLine( file, w );
	
	FS_FClose( file );
	
	return true;
}

writeToFile( path, w )
{
	file = FS_FOpen( path, "write" );
	
	if( !isDefined( file ) )
		return false;
		
	if( isArray( w ) )
		writeArray( file, w );
	else
		FS_WriteLine( file, w );
	
	FS_FClose( file );
	
	return true;
}

// Read all lines in a file and return them as array of strings.
// If reading failes/file doesn't exist it returns boolean FALSE.
// File will close after reading.
readFile( path )
{
	file = FS_FOpen( path, "read" );
	
	if( !isDefined( file ) )
		return "";
		
	lines = readAll( file );
	
	FS_FClose( file );
	
	if( !isArray( lines ) || lines.size < 1 )
		return false;
	
	return lines;
}

writeArray( handle, array )
{
	for( i = 0; i < array.size; i++ )
		FS_WriteLine( handle, array[ i ] );
}

readAll( handle )
{
	array = [];
	for( ;; )
	{
		line = FS_ReadLine( handle );
		if( isDefined( line ) )
			array[ array.size ] = line;
		else
			break;
	}
	
	return array;
}