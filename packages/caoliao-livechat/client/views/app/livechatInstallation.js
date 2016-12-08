Template.livechatInstallation.helpers({
	script() {
		let siteUrl = s.rtrim(CaoLiao.settings.get('Site_Url'), '/');

		return `<!-- Start of CaoLiao Livechat Script -->
<script type="text/javascript">
(function(w, d, s, u) {
	w.CaoLiao = function(c) { w.CaoLiao._.push(c) }; w.CaoLiao._ = []; w.CaoLiao.url = u;
	var h = d.getElementsByTagName(s)[0], j = d.createElement(s);
	j.async = true; j.src = '${siteUrl}/packages/caoliao_livechat/assets/rocket-livechat.js';
	h.parentNode.insertBefore(j, h);
})(window, document, 'script', '${siteUrl}/livechat');
</script>
<!-- End of CaoLiao Livechat Script -->`;
	}
});
