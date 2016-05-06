//
//  ViewController.swift
//  todoify
//
//  Created by Sebastian Huber on 03.03.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import UIKit

class ImprintController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var contributorsView = UIView()
    var legalTextView = UIView()
    
    let imageSize = 100 as CGFloat
    let textSize = 42 as CGFloat
    let padding = 50 as CGFloat
    let labelPadding = 30 as CGFloat
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSizeMake(self.view.frame.width, 3000)
        
        contributorsView = setContriubtorsView()
        legalTextView = setLegalTextView()
        
        print(legalTextView)
        
        self.title = "Impressum"
        
        scrollView.addSubview(contributorsView)
        scrollView.addSubview(legalTextView)
        view.addSubview(scrollView)
        
    }
    
    func setContriubtorsView() -> UIView!{
        let image1 = UIImageView(image: UIImage(named: "alex_thumb.png"))
        let image2 = UIImageView(image: UIImage(named: "sebastian_thumb.png"))
        let image3 = UIImageView(image: UIImage(named: "josef_thumb.png"))
        let image4 = UIImageView(image: UIImage(named: "pablo_thumb.png"))
        let label1 = UILabel(frame: CGRectMake(0, 0, imageSize, textSize))
        let label2 = UILabel(frame: CGRectMake(0, 0, imageSize, textSize))
        let label3 = UILabel(frame: CGRectMake(0, 0, imageSize, textSize))
        let label4 = UILabel(frame: CGRectMake(0, 0, imageSize, textSize))
        
        label1.center = CGPointMake((self.view.frame.size.width/4), (imageSize + padding + labelPadding))
        label1.textAlignment = NSTextAlignment.Center
        label1.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label1.numberOfLines = 2
        label1.text = "Alexander Gabriel"
        image1.frame = CGRectMake((self.view.frame.size.width/4-(imageSize/2)), padding, imageSize, imageSize)
        
        label2.center = CGPointMake((self.view.frame.size.width/4*3), (imageSize + padding + labelPadding))
        label2.textAlignment = NSTextAlignment.Center
        label2.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label2.numberOfLines = 2
        label2.text = "Sebastian Huber"
        image2.frame = CGRectMake((self.view.frame.size.width/4*3-(imageSize/2)), padding, imageSize, imageSize)
        
        label3.center = CGPointMake((self.view.frame.size.width/4), 2*(imageSize + padding + labelPadding))
        label3.textAlignment = NSTextAlignment.Center
        label3.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label3.numberOfLines = 2
        label3.text = "Josef Krabath"
        image3.frame = CGRectMake((self.view.frame.size.width/4-(imageSize/2)), (imageSize + padding + textSize + labelPadding), imageSize, imageSize)
        
        
        label4.center = CGPointMake((self.view.frame.size.width/4*3), 2*(imageSize + padding + labelPadding))
        label4.textAlignment = NSTextAlignment.Center
        label4.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label4.numberOfLines = 2
        label4.text = "Pablo Pernías"
        image4.frame = CGRectMake((self.view.frame.size.width/4*3-(imageSize/2)), (imageSize + padding + textSize + labelPadding), imageSize, imageSize)
        
        contributorsView.addSubview(label1)
        contributorsView.addSubview(label2)
        contributorsView.addSubview(label3)
        contributorsView.addSubview(label4)
        
        contributorsView.addSubview(image1)
        contributorsView.addSubview(image2)
        contributorsView.addSubview(image3)
        contributorsView.addSubview(image4)
        
        return contributorsView
    }
    
    func setLegalTextView() -> UIView! {
        let label1 = UILabel(frame: CGRectMake(10, 30, (scrollView.contentSize.width-20), CGFloat.max))
        
        label1.numberOfLines = 0
        
        label1.text = "Impressum\n" +
        "Angaben gemäß § 5 TMG:\n" +
            "\n" +
            "Fachhochschule Salzburg\n" +
            "Campus Urstein Süd 1\n" +
            "A-5412 Puch/Salzburg\n" +
            "\n" +
            "Vertreten durch:\n" +
            "\n" +
            "[Vertreten durch: Name, Anschrift]\n" +
            "\n" +
            "Kontakt:\n" +
            "\n" +
            "Telefon: +43-(0)50-2211-0\n" +
            "E-Mail: office@fh-salzburg.ac.at\n" +
            " \n" +
            "\n" +
            "Quelle: eRecht24\n" +
            "\n" +
            "Haftungsausschluss (Disclaimer)\n" +
            "Haftung für Inhalte\n" +
            "\n" +
            "Als Diensteanbieter sind wir gemäß § 7 Abs.1 TMG für eigene Inhalte auf diesen Seiten nach den allgemeinen Gesetzen verantwortlich. Nach §§ 8 bis 10 TMG sind wir als Diensteanbieter jedoch nicht verpflichtet, übermittelte oder gespeicherte fremde Informationen zu überwachen oder nach Umständen zu forschen, die auf eine rechtswidrige Tätigkeit hinweisen. Verpflichtungen zur Entfernung oder Sperrung der Nutzung von Informationen nach den allgemeinen Gesetzen bleiben hiervon unberührt. Eine diesbezügliche Haftung ist jedoch erst ab dem Zeitpunkt der Kenntnis einer konkreten Rechtsverletzung möglich. Bei Bekanntwerden von entsprechenden Rechtsverletzungen werden wir diese Inhalte umgehend entfernen.\n" +
            "\n" +
            "Haftung für Links\n" +
            "\n" +
            "Unser Angebot enthält Links zu externen Webseiten Dritter, auf deren Inhalte wir keinen Einfluss haben. Deshalb können wir für diese fremden Inhalte auch keine Gewähr übernehmen. Für die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber der Seiten verantwortlich. Die verlinkten Seiten wurden zum Zeitpunkt der Verlinkung auf mögliche Rechtsverstöße überprüft. Rechtswidrige Inhalte waren zum Zeitpunkt der Verlinkung nicht erkennbar. Eine permanente inhaltliche Kontrolle der verlinkten Seiten ist jedoch ohne konkrete Anhaltspunkte einer Rechtsverletzung nicht zumutbar. Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Links umgehend entfernen.\n" +
            "\n" +
            "Urheberrecht\n" +
            "\n" +
            "Die durch die Seitenbetreiber erstellten Inhalte und Werke auf diesen Seiten unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechtes bedürfen der schriftlichen Zustimmung des jeweiligen Autors bzw. Erstellers. Downloads und Kopien dieser Seite sind nur für den privaten, nicht kommerziellen Gebrauch gestattet. Soweit die Inhalte auf dieser Seite nicht vom Betreiber erstellt wurden, werden die Urheberrechte Dritter beachtet. Insbesondere werden Inhalte Dritter als solche gekennzeichnet. Sollten Sie trotzdem auf eine Urheberrechtsverletzung aufmerksam werden, bitten wir um einen entsprechenden Hinweis. Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Inhalte umgehend entfernen.\n" +
            "\n" +
            "\n" +
            "\n" +
            "Datenschutzerklärung:\n" +
            "Datenschutz\n" +
            "\n" +
            "Die Betreiber dieser Seiten nehmen den Schutz Ihrer persönlichen Daten sehr ernst. Wir behandeln Ihre personenbezogenen Daten vertraulich und entsprechend der gesetzlichen Datenschutzvorschriften sowie dieser Datenschutzerklärung.\n" +
            "\n" +
            "Die Nutzung unserer Webseite ist in der Regel ohne Angabe personenbezogener Daten möglich. Soweit auf unseren Seiten personenbezogene Daten (beispielsweise Name, Anschrift oder E-Mail-Adressen) erhoben werden, erfolgt dies, soweit möglich, stets auf freiwilliger Basis. Diese Daten werden ohne Ihre ausdrückliche Zustimmung nicht an Dritte weitergegeben.\n" +
            "\n" +
            "Wir weisen darauf hin, dass die Datenübertragung im Internet (z.B. bei der Kommunikation per E-Mail) Sicherheitslücken aufweisen kann. Ein lückenloser Schutz der Daten vor dem Zugriff durch Dritte ist nicht möglich.\n" +
            "\n" +
            " \n" +
            "\n" +
            "Datenschutzerklärung für die Nutzung von Google +1\n" +
            "\n" +
            "Unsere Seiten nutzen Funktionen von Google +1. Anbieter ist die Google Inc. 1600 Amphitheatre Parkway Mountain View, CA 94043,  USA.\n" +
            "\n" +
            "Erfassung und Weitergabe von Informationen: Mithilfe der Google +1-Schaltfläche können Sie Informationen weltweit veröffentlichen. über die Google +1-Schaltfläche erhalten Sie und andere Nutzer personalisierte Inhalte von Google und unseren Partnern. Google speichert sowohl die Information, dass Sie für einen Inhalt +1 gegeben haben, als auch Informationen über die Seite, die Sie beim Klicken auf +1 angesehen haben. Ihre +1 können als Hinweise zusammen mit Ihrem Profilnamen und Ihrem Foto in Google-Diensten, wie etwa in Suchergebnissen oder in Ihrem Google-Profil, oder an anderen Stellen auf Websites und Anzeigen im Internet eingeblendet werden. Google zeichnet Informationen über Ihre +1-Aktivitäten auf, um die Google-Dienste für Sie und andere zu verbessern. Um die Google +1-Schaltfläche verwenden zu können, benötigen Sie ein weltweit sichtbares, öffentliches Google-Profil, das zumindest den für das Profil gewählten Namen enthalten muss. Dieser Name wird in allen Google-Diensten verwendet. In manchen Fällen kann dieser Name auch einen anderen Namen ersetzen, den Sie beim Teilen von Inhalten über Ihr Google-Konto verwendet haben. Die Identität Ihres Google- Profils kann Nutzern angezeigt werden, die Ihre E-Mail-Adresse kennen oder über andere identifizierende Informationen von Ihnen verfügen.\n" +
            "\n" +
        "Verwendung der erfassten Informationen: Neben den oben erläuterten Verwendungszwecken werden die von Ihnen bereitgestellten Informationen gemäß den geltenden Google-Datenschutzbestimmungen genutzt. Google veröffentlicht möglicherweise zusammengefasste Statistiken über die +1-Aktivitäten der Nutzer bzw. gibt diese an Nutzer und Partner weiter, wie etwa Publisher, Inserenten oder verbundene Websites."
        
        label1.sizeToFit()
        
        legalTextView.addSubview(label1)
        
        return legalTextView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        contributorsView.frame = CGRectMake(0, 0, scrollView.contentSize.width, 2*(imageSize + padding + textSize + labelPadding))
        legalTextView.frame = CGRectMake(0, 2*(imageSize + padding + textSize + labelPadding), scrollView.contentSize.width, 1000)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

