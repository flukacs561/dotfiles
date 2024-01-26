{ pkgs, ... }:
{
  programs.newsboat = {
    enable = true;
    browser = "${pkgs.brave}/bin/brave";
    extraConfig = ''
      macro v set browser ${pkgs.mpv}/bin/mpv; open-in-browser; set browser ${pkgs.brave}/bin/brave

      bind-key j down
      bind-key k up
      bind-key u toggle-article-read
    '';
    urls = [
      {
        title = "Jonathan Pageau -- Clips";
        tags = ["chr" "orth" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCObI9A-XPP3KD3Fc3MnzOuw";
      }
      {
        title = "Jonathan Pageau";
        tags = ["chr" "orth" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCtCTSf3UwRU14nYWr_xm-dQ";
      }
      {
        title = "Father Spyridon";
        tags = ["chr" "orth" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCkpBmkoZ6yToHhB8uFDp46Q";
      }
      {
        title = "Mull Monastery";
        tags = ["chr" "orth" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC3puFf-lxwTWBFCfHHjCz2A";
      }
      {
        title = "The Thomistic Institute";
        tags = ["chr" "cath" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCd55APptap1Ve7Jwqa8OcBA";
      }
      {
        title = "Pints with Aquinas";
        tags = ["chr" "cath" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UClh4JeqYB1QN6f1h_bzmEng";
      }
      {
        title = "UnHerd";
        tags = ["yt" "pol"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCMxiv15iK_MFayY_3fU9loQ";
      }
      {
        title = "Captain Sinbad";
        tags = ["yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC8XKyvQ5Ne_bvYbgv8LaIeg";
      }
      {
        title = "Academy of Ideas";
        tags = ["phil" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCiRiQGCHGjDLT9FQXFW0I3A";
      }
      {
        title = "Apostolic Majesty";
        tags = ["history" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCuTWocQj6fFDEGFCU1XI0cQ";
      }
      {
        title = "Russell Walter";
        tags = ["phil" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCnN-3GfVjuEIHYo39HfhB1Q";
      }
      {
        title = "Invocabo Nomen Domini";
        tags = ["chr" "cath"];
        url = "https://invocabo.wordpress.com/feed/";
      }
      {
        title = "Truth Unites";
        tags =  ["chr" "prot" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCtWDnUokOD--s2aFxLT5uVA";
      }
      {
        title = "Redeemed Zoomer";
        tags = ["chr" "prot" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCiLqiXa5O85APUBQV7X5w9Q";
      }
      {
        title = "Thomas Wangenheim";
        tags = ["yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCYbDnz0vgLz3Uqi3_k3HUUA";
      }
      {
        title = "Project Mage";
        tags = ["tech"];
        url = "https://project-mage.org/rss.xml";
      }
      {
        title = "Protesilaos";
        tags = ["tech" "yt"];
        url = "https://protesilaos.com/master.xml";
      }
      {
        title = "The Ulengovs";
        tags = ["yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCg0pVEi7hMVSxCbdxeJ0VZA";
      }
      {
        title = "Mental Outlaw";
        tags = ["tech" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC7YOGHUfC1Tb6E4pudI9STA";
      }
      {
        title = "Let's talk religion";
        tags = ["history" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC9dRb4fbJQIbQ3KHJZF_z0g";
      }
      {
        title = "Luke Smith";
        tags = [];
        url = "https://lukesmith.xyz/index.xml";
      }
      {
        title = "European Conservative";
        tags = ["news"];
        url = "https://europeanconservative.com/feed/";
      }
      {
        title = "Emacs news";
        tags = ["tech"];
        url = "https://sachachua.com/blog/category/emacs-news/feed/";
      }
      {
        title = "Björn Andreas Bull-Hansen";
        tags = ["yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC95m7aBYo7wgNCoHb1ojQYw";
      }
      {
        title = "The Hated One";
        tags = ["tech" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCjr2bPAyPV7t35MvcgT3W8Q";
      }
      {
        title = "Einzelgänger";
        tags = ["phil" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCybBViio_TH_uiFFDJuz5tg";
      }
      {
        title = "Dry Creek Wrangler School";
        tags = ["yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCCU0HzTA9ddqOgtuV-TJ9yw";
      }
    ];
  };
}
