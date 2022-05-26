namespace AbInDenUrlaub
{
    public partial class Nutzer
    {
        public Nutzer()
        {
            Bewertungs = new HashSet<Bewertung>();
            Ferienwohnungs = new HashSet<Ferienwohnung>();
            Gebots = new HashSet<Gebot>();
            Kreditkartendatens = new HashSet<Kreditkartendaten>();
            Rechnungshistorieeintrags = new HashSet<Rechnungshistorieeintrag>();
        }

        public int UserId { get; set; }
        public string Username { get; set; } = null!;
        public string Nachname { get; set; } = null!;
        public string Vorname { get; set; } = null!;
        public string Password { get; set; } = null!;
        public string Email { get; set; } = null!;
        public int? Tokenstand { get; set; }
        public bool? Vermieter { get; set; }
        public bool? Admin { get; set; }
        public DateTime lastbuy { get; set; }

        public virtual ICollection<Bewertung> Bewertungs { get; set; }
        public virtual ICollection<Ferienwohnung> Ferienwohnungs { get; set; }
        public virtual ICollection<Gebot> Gebots { get; set; }
        public virtual ICollection<Kreditkartendaten>? Kreditkartendatens { get; set; }
        public virtual ICollection<Rechnungshistorieeintrag>? Rechnungshistorieeintrags { get; set; }
    }
}
