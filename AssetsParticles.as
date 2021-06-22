package
{
	public class AssetsParticles
	{
		//[Embed(source="graphics/particles/particles.pex", mimeType="application/octet-stream")]
		[Embed(source="graphics/particles/particles.xml",mimeType="application/octet-stream"))]
		public static var ParticleXML:Class;
		
		[Embed(source="graphics/particles/texture.png")]
		public static var ParticleTexture:Class;
		
		
	}
}