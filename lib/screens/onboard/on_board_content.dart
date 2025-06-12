class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Bienvenue sur Mony",
    image: "assets/images/walet.png",
    desc: "Prenez le contrôle de vos finances.\n \n""Bienvenue dans MoneyMaster, votre allié pour une gestion financière efficace."
    "Enregistrez vos dépenses et revenus en un clin d'œil et reprenez le contrôle de votre argent.",
  ),
  OnboardingContents(
    title: "Organisez et Suivez",
    image: "assets/images/cashflow.png",
    desc:
        "Une vue d'ensemble transparente.\n \n Organisez vos finances avec facilité en catégorisant vos dépenses et revenus.Suivez vos transactions avec précision et visualisez votre situation financière un coup d'œil.",
  ),
  OnboardingContents(
    title: "Analysez et Planifiez",
    image: "assets/images/expensive.png",
    desc:
        "Comprenez et Anticipez.\n \n Analysez vos dépenses et revenus grâce à des statistiques détaillées, par année, mois ou catégorie. Utilisez ces informations pour planifier intelligemment votre budget et atteindre vos objectifs financiers.",
  ),
  OnboardingContents(
    title: "Assistant AI",
    image: "assets/images/bott.png",
    desc:
        "Posez vos questions.\n \n Evoquez vos préoccupations en matière de gestion financière et notre assistant se fera le plaisir de vous répondre",
  ),
];