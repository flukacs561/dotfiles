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
        title = "Truth Unites";
        tags =  ["chr" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCtWDnUokOD--s2aFxLT5uVA";
      }
      {
        title = "Invocabo Nomen Domini";
        tags = ["chr"];
        url = "https://invocabo.wordpress.com/feed/";
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
        title = "Redeemed Zoomer";
        tags = ["chr" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCiLqiXa5O85APUBQV7X5w9Q";
      }
      {
        title = "Captain Sinbad";
        tags = ["yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC8XKyvQ5Ne_bvYbgv8LaIeg";
      }
      {
        title = "The Ulengovs";
        tags = ["yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCg0pVEi7hMVSxCbdxeJ0VZA";
      }
      {
        title = "Pints with Aquinas";
        tags = ["chr" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UClh4JeqYB1QN6f1h_bzmEng";
      }
      {
        title = "Apostolic Majesty";
        tags = ["history" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCuTWocQj6fFDEGFCU1XI0cQ";
      }
      {
        title = "Matthew Everhard";
        tags = ["chr" "yt"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=hOXtiz9Q0YvVUee8A";
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
    ];
  };
}
