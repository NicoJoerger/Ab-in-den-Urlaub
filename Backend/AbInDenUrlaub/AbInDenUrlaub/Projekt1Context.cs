using Microsoft.EntityFrameworkCore;

namespace AbInDenUrlaub
{
    public partial class Projekt1Context : DbContext
    {
        public Projekt1Context()
        {
        }

        public Projekt1Context(DbContextOptions<Projekt1Context> options)
            : base(options)
        {
        }

        public virtual DbSet<Angebote> Angebotes { get; set; } = null!;
        public virtual DbSet<Bewertung> Bewertungs { get; set; } = null!;
        public virtual DbSet<Ferienwohnung> Ferienwohnungs { get; set; } = null!;
        public virtual DbSet<Gebot> Gebots { get; set; } = null!;
        public virtual DbSet<Kreditkartendaten> Kreditkartendatens { get; set; } = null!;
        public virtual DbSet<Nutzer> Nutzers { get; set; } = null!;
        public virtual DbSet<Rechnungshistorieeintrag> Rechnungshistorieeintrags { get; set; } = null!;
        public virtual DbSet<Token> Tokens { get; set; } = null!;
        public virtual DbSet<Wohnungsbilder> Wohnungsbilders { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseNpgsql("Server=h2956807.stratoserver.net; Database=Projekt1;Port=5432;SslMode=Disable;User Id=postgres");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Angebote>(entity =>
            {
                entity.HasKey(e => e.AngebotId)
                    .HasName("angebote_pkey");

                entity.ToTable("angebote");

                entity.Property(e => e.AngebotId).HasColumnName("angebot_id");

                entity.Property(e => e.AktuellerTokenpreis).HasColumnName("aktueller_tokenpreis");

                entity.Property(e => e.AuktionEnddatum)
                    .HasColumnType("timestamp without time zone")
                    .HasColumnName("auktion_enddatum");

                entity.Property(e => e.FwId).HasColumnName("fw_id");

                entity.Property(e => e.Mietpreis).HasColumnName("mietpreis");

                entity.Property(e => e.MietzeitraumEnde)
                    .HasColumnType("timestamp without time zone")
                    .HasColumnName("mietzeitraum_ende");

                entity.Property(e => e.MietzeitraumStart)
                    .HasColumnType("timestamp without time zone")
                    .HasColumnName("mietzeitraum_start");

                entity.Property(e => e.Stornierbar).HasColumnName("stornierbar");

                entity.HasOne(d => d.Fw)
                    .WithMany(p => p.Angebotes)
                    .HasForeignKey(d => d.FwId)
                    .HasConstraintName("angebote_fw_id_fkey");
            });

            modelBuilder.Entity<Bewertung>(entity =>
            {
                entity.ToTable("bewertung");

                entity.Property(e => e.BewertungId).HasColumnName("bewertung_id");

                entity.Property(e => e.Anzsterne).HasColumnName("anzsterne");

                entity.Property(e => e.FwId).HasColumnName("fw_id");

                entity.Property(e => e.Kommentar).HasColumnName("kommentar");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.HasOne(d => d.Fw)
                    .WithMany(p => p.Bewertungs)
                    .HasForeignKey(d => d.FwId)
                    .HasConstraintName("bewertung_fw_id_fkey");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Bewertungs)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("bewertung_user_id_fkey");
            });


            modelBuilder.Entity<Ferienwohnung>(entity =>
            {
                entity.HasKey(e => e.FwId)
                    .HasName("ferienwohnung_pkey");

                entity.ToTable("ferienwohnung");

                entity.Property(e => e.FwId).HasColumnName("fw_id");

                entity.Property(e => e.Anzbaeder).HasColumnName("anzbaeder");

                entity.Property(e => e.Anzbetten).HasColumnName("anzbetten");

                entity.Property(e => e.Anzzimmer).HasColumnName("anzzimmer");

                entity.Property(e => e.Balkon).HasColumnName("balkon");

                entity.Property(e => e.Beschreibung).HasColumnName("beschreibung");

                entity.Property(e => e.Garten).HasColumnName("garten");

                entity.Property(e => e.Ort)
                    .HasMaxLength(70)
                    .HasColumnName("ort");

                entity.Property(e => e.Plz).HasColumnName("plz");

                entity.Property(e => e.Strasse)
                    .HasMaxLength(70)
                    .HasColumnName("strasse");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.Property(e => e.Wifi).HasColumnName("wifi");

                entity.Property(e => e.Wohnflaeche).HasColumnName("wohnflaeche");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Ferienwohnungs)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("ferienwohnung_user_id_fkey");
            });

            modelBuilder.Entity<Gebot>(entity =>
            {
                entity.ToTable("gebot");

                entity.Property(e => e.GebotId).HasColumnName("gebot_id");

                entity.Property(e => e.AngebotId).HasColumnName("angebot_id");

                entity.Property(e => e.Preis).HasColumnName("preis");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.HasOne(d => d.Angebot)
                    .WithMany(p => p.Gebots)
                    .HasForeignKey(d => d.AngebotId)
                    .HasConstraintName("gebot_angebot_id_fkey");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Gebots)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("gebot_user_id_fkey");
            });

            modelBuilder.Entity<Kreditkartendaten>(entity =>
            {
                entity.HasKey(e => e.KddId)
                    .HasName("kreditkartendaten_pkey");

                entity.ToTable("kreditkartendaten");

                entity.Property(e => e.KddId).HasColumnName("kdd_id");

                entity.Property(e => e.Cvv).HasColumnName("cvv");

                entity.Property(e => e.Kartennummer).HasColumnName("kartennummer");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Kreditkartendatens)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("kreditkartendaten_user_id_fkey");
            });

            modelBuilder.Entity<Nutzer>(entity =>
            {
                entity.HasKey(e => e.UserId)
                    .HasName("nutzer_pkey");

                entity.ToTable("nutzer");

                entity.HasIndex(e => e.Email, "nutzer_email_key")
                    .IsUnique();

                entity.HasIndex(e => e.Username, "nutzer_username_key")
                    .IsUnique();

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.Property(e => e.Admin).HasColumnName("admin");

                entity.Property(e => e.Email)
                    .HasMaxLength(255)
                    .HasColumnName("email");

                entity.Property(e => e.Nachname)
                    .HasMaxLength(50)
                    .HasColumnName("nachname");

                entity.Property(e => e.Password)
                    .HasMaxLength(50)
                    .HasColumnName("password");

                entity.Property(e => e.Tokenstand).HasColumnName("tokenstand");

                entity.Property(e => e.Username)
                    .HasMaxLength(50)
                    .HasColumnName("username");

                entity.Property(e => e.Vermieter).HasColumnName("vermieter");

                entity.Property(e => e.Vorname)
                    .HasMaxLength(50)
                    .HasColumnName("vorname");
            });

            modelBuilder.Entity<Rechnungshistorieeintrag>(entity =>
            {
                entity.HasKey(e => e.RhId)
                    .HasName("rechnungshistorieeintrag_pkey");

                entity.ToTable("rechnungshistorieeintrag");

                entity.Property(e => e.RhId).HasColumnName("rh_id");

                entity.Property(e => e.AngebotId).HasColumnName("angebot_id");

                entity.Property(e => e.Storniert).HasColumnName("storniert");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.HasOne(d => d.Angebot)
                    .WithMany(p => p.Rechnungshistorieeintrags)
                    .HasForeignKey(d => d.AngebotId)
                    .HasConstraintName("rechnungshistorieeintrag_angebot_id_fkey");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Rechnungshistorieeintrags)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("rechnungshistorieeintrag_user_id_fkey");
            });

            modelBuilder.Entity<Token>(entity =>
            {
                entity.HasKey(e => e.TokId)
                    .HasName("tokens_pkey");

                entity.ToTable("tokens");

                entity.Property(e => e.TokId).HasColumnName("tok_id");

                entity.Property(e => e.Tokenpreis).HasColumnName("tokenpreis");
            });

            modelBuilder.Entity<Wohnungsbilder>(entity =>
            {
                entity.HasKey(e => e.WgbId)
                    .HasName("wohnungsbilder_pkey");

                entity.ToTable("wohnungsbilder");

                entity.Property(e => e.WgbId).HasColumnName("wgb_id");

                entity.Property(e => e.FwId).HasColumnName("fw_id");



                entity.HasOne(d => d.Fw)
                    .WithMany(p => p.Wohnungsbilders)
                    .HasForeignKey(d => d.FwId)
                    .HasConstraintName("wohnungsbilder_fw_id_fkey");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
