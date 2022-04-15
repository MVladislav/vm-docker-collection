# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [docker prepare](#docker-prepare)
  - [host setup](#host-setup)
  - [References](#references)

---

## docker prepare

```sh
$docker-compose build
$docker-compose up -d
```

## host setup

After docker is run you need setup iptables to redirect your ports to the exposed `4444` port from docker.

Example:

```sh
$sudo iptables -t nat -A PREROUTING -p tcp -m multiport --dports 1:21,23:65535 -j REDIRECT --to-ports 4444
```

other commands:

```sh
$sudo iptables -t nat -nvL
```

---

## References

- <https://github.com/strandjs/IntroLabs/blob/90c6abb49c227bb859356d9a8218ef45879e7af5/IntroClassFiles/Tools/IntroClass/Portspoof.md>
- <https://github.com/drk1wi/portspoof>
