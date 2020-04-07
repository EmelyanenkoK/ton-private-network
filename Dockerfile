FROM ubuntu:18.04

ENV FIFTPATH /usr/local/lib/fift

RUN apt-get update && \
	apt-get install -y openssl wget python&& \
	rm -rf /var/lib/apt/lists/* && \
	mkdir -p /var/ton-work/db && \
	mkdir -p /var/ton-work/db/static && \
	mkdir /usr/local/lib/fift && \ 
	mkdir /var/ton-work/contracts && \
	mkdir -p /var/ton-work/db/keyring

COPY --from=it4addict/ton-build /ton/build/lite-client/lite-client /usr/local/bin/
COPY --from=it4addict/ton-build /ton/build/validator-engine/validator-engine /usr/local/bin/
COPY --from=it4addict/ton-build /ton/build/validator-engine-console/validator-engine-console /usr/local/bin/
COPY --from=it4addict/ton-build /ton/build/utils/generate-random-id /usr/local/bin/
COPY --from=it4addict/ton-build /ton/build/test-ton-collator /usr/local/bin
COPY --from=it4addict/ton-build /ton/build/crypto/fift /usr/local/bin
COPY --from=it4addict/ton-build /ton/build/crypto/func /usr/local/bin
COPY --from=it4addict/ton-build /ton/build/dht-server/dht-server /usr/local/bin
COPY --from=it4addict/ton-build /ton/crypto/fift/lib /usr/local/lib/fift
COPY --from=it4addict/ton-build /ton/crypto/smartcont /var/ton-work/contracts
COPY --from=it4addict/ton-build /ton/build/crypto/create-state /var/ton-work/contracts

WORKDIR /var/ton-work/contracts
COPY gen-zerostate.fif ./
WORKDIR /var/ton-work/db
COPY ton-private-testnet.config.json.template node_init.sh control.template prepare_network.sh init.sh clean_all.sh ./
RUN chmod +x node_init.sh prepare_network.sh init.sh clean_all.sh

ENTRYPOINT ["/var/ton-work/db/init.sh"]
