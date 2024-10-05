# University of Manitoba Wetlanders BirdNET-Pi Workshop 

## Workshop #1
On 21 September 2024 Dr. Collins led the [UM Wetlanders](https://www.instagram.com/umwetlanders/) in building 8 bird listening boxes using Raspberry Pi's running BirdNET-Pi. About 20 people joined!

We used the tutorial at [pixcams.com](https://pixcams.com/building-a-birdnet-pi-real-time-acoustic-bird-id-station/), with a few alterations.

We used the equipment list found there, and with shipping the total per box came to about $240 CAD.

### Box-making
In Step 4, we used flat wood (or spade) bits to cut the holes, they worked fine but the 7/8" was a bit too small and required manual shaving, so we began using the 1" instead

<img width="586" alt="image" src="https://github.com/user-attachments/assets/b21e3ca5-a0ec-401a-ac1a-911f76e4afde">

### BirdNET-Pi installation
We used the excellent [Installation Guide](https://github.com/mcguirepr89/BirdNET-Pi/wiki/Installation-Guide) provided by Patrick McGuire, with a few updates.

#### Step 3
CHOOSE OS: Raspberry Pi OS Lite (64-bit) A port of Debian BOOKWORM with no desktop environment

Make sure not to use BULLSEYE version 

#### Step 18
After logging in, we were having trouble with ethernet disconnections. We solved it by doing the following

```
sudo nmcli c modify "Wired connection 1" ipv4.method link-local
```

We also installed tmux and did the installation inside a tmux window in case of a disconnection.

We found that if the installation didn't complete the first time, it was better to re-flash the SD card with a fresh OS than to try to fix the incomplete installation.

```
sudo apt install tmux
tmux
```

#### Step 19
Because we are using the latest RaspiOS (bookworm) we needed to use the newer version of BirdNET-Pi at [https://github.com/Nachtzuster/BirdNET-Pi](https://github.com/Nachtzuster/BirdNET-Pi).

If you're using the older version of RaspiOS (bullseye) then you'll continue to use the older (no longer maintained) version at [https://github.com/mcguirepr89/BirdNET-Pi/](https://github.com/mcguirepr89/BirdNET-Pi/)

The new command is

```
curl -s https://raw.githubusercontent.com/mcguirepr89/BirdNET-Pi/main/newinstaller.sh | bash
```

#### Step 26: Making available on the internet
To simplify the setup of the BirdNET-Pi station to be visible on the open internet, we use [dreamhost-dynamic-dns](https://github.com/clempaul/dreamhost-dynamic-dns) with a [custom script](/BirdNET-Pi/birdbox-remotesetup.sh) that is specific for Dreamhost, where I host the boxes. If you don't use Dreamhost, this won't work for you. If you do, you can request an API key from Dreamhost and use it here.

* Go to http://< birdname >.local
* Go to Tools --> Settings
* Log in with user=birder, password=birder
* Change the password to something secure
* Scroll down to "Network Usage" and click the arrow next to "wlan0", it should show two strings:
  1. the MAC address will look like D8-3A-DD-6F-CA-86
  2. and the IP address will look like 192.168.0.131

First, ensure it always gets that ip address by going to your router settings and adding a static IP address for that MAC address. The instructions vary by router but you can usually find it using google or by perusing the tabs in the administration page, which is typically accessed by going to http://192.168.0.1 on a computer connected to the wifi network and logging in (user and password are often on a sticker on the router itself). You'll enter the MAC and IP addresses noted above.

If there is an option to enable "HAIRPIN NAT" you'll want to turn that as well, otherwise it might not be available at the external web address from your internal network due to router issues.

You may also need to allow it access through the router's firewall. That involves setting an allowance for that IP address to receive data from ports 443 and 80. Again the instructions vary by router but are usually under the Security or Firewall tabs in the admin panel.

Next, go to 
go to Tools --> Web Terminal

then copy the paste the following line by line

#####
```
export DREAMHOST_API_KEY=<your_api_key>
curl -Os https://raw.githubusercontent.com/rec3141/RedRiverResearch/refs/heads/main/BirdNet-Pi/birdbox-remotesetup.sh
chmod +x birdbox-remotesetup.sh && ./birdbox-remotesetup.sh
```

#####
It will say "Connection Closed"

After that, it might take a while to update across the internet, but eventually it should be accessible at http://< birdname >.redriverresearch.ca, and from within your local network at the IP address printed above.

## Visit our BirdNET-Pi listening stations!

Each station is named after a wetland bird!

### Find our data on [Birdweather.com](https://app.birdweather.com/data/ZffJ3LwQsf2vGTTo1K7ZXbRa)

We currently have the only BirdNET-Pi stations in Manitoba, but we're hoping to fix that!

<img width="609" alt="image" src="https://github.com/user-attachments/assets/4816d071-1a76-4f65-9c4c-06755fffae40">

### Currently online
[bobolink](bobolink.redriverresearch.ca)
[mallard](mallard.redriverresearch.ca)
[americancoot](americancoot.redriverresearch.ca)
[canvasduck](canvasduck.redriverresearch.ca)

### Currently offline
[kingfisher](kingfisher.redriverresearch.ca)
[bluejay](bluejay.redriverresearch.ca)
[ruddyduck](ruddyduck.redriverresearch.ca)
[surfbird](surfbird.redriverresearch.ca)


