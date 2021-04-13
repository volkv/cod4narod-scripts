init()
{
	level thread volkv\_languages::init();
	level thread volkv\_carepackage::main();
	level thread volkv\_misc::init();
	level thread volkv\_antiafk_camp::init();
	thread volkv\events::init();
}
