namespace AbInDenUrlaub
{
    public partial class Wohnungsbilder
    {
        public int WgbId { get; set; }
        public int? FwId { get; set; }
        public byte[] Bild { get; set; } = null!;

        public virtual Ferienwohnung? Fw { get; set; }
    }
}
