namespace AbInDenUrlaub
{
    public partial class Wohnungsbilder
    {
        public int WgbId { get; set; }
        public int? FwId { get; set; }
        public byte[]? bild { get; set; }

        public virtual Ferienwohnung? Fw { get; set; }
    }
}
