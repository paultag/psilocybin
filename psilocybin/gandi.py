import xmlrpc.client


class GandiProxy:
    def __init__(self, apikey):
        self.api = xmlrpc.client.ServerProxy('https://rpc.ote.gandi.net/xmlrpc')
        self.apikey = apikey

    def _call(self, func, *args, **kwargs):
        return func(self.apikey, *args, **kwargs)

    def get_version(self):
        return self._call(self.api.version.info)

    def get_zones(self):
        return self._call(self.api.domain.zone.list)

    def get_zone(self, zone):
        return self._call(self.api.domain.zone.info, zone)

    def get_records(self, zone, version):
        return self._call(
            self.api.domain.zone.record.list,
            zone,
            version
        )

    def get_zone_records(self, zone):
        zone = self._call(self.api.domain.zone.info, zone)
        return self.get_records(zone['id'], zone['version'])
