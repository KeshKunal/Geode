package com.example.geode

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import android.content.Intent

class GeodeAccessibilityService : AccessibilityService() {

    companion object {
        // We'll use this to get the blocklist from Flutter later
        var blockedApps: List<String> = listOf()
        var blockedWebsites: List<String> = listOf()
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        // --- App Blocking Logic ---
        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            val packageName = event.packageName?.toString()
            if (packageName != null && blockedApps.contains(packageName)) {
                showBlockScreen("app", packageName)
                return // Blocked, no need to check for websites
            }
        }

        // --- Website Blocking Logic ---
        val parentNodeInfo = event.source ?: return
        val url = findUrlInNode(parentNodeInfo)
        if (url != null) {
            for (site in blockedWebsites) {
                if (url.contains(site)) {
                    showBlockScreen("website", site)
                    break
                }
            }
        }
    }

    private fun findUrlInNode(nodeInfo: AccessibilityNodeInfo): String? {
        // This is a complex part. Logic to find the URL bar's view ID and get its text.
        // For Chrome, the ID is often "com.android.chrome:id/url_bar"
        // This is fragile and might require different logic for each browser.
        // Let's assume a simplified search for now.
        for (i in 0 until nodeInfo.childCount) {
            val child = nodeInfo.getChild(i)
            if (child != null) {
                if (child.viewIdResourceName != null && child.viewIdResourceName.contains("url_bar")) {
                    return child.text?.toString()
                }
                val url = findUrlInNode(child)
                if (url != null) return url
            }
        }
        return null
    }

    private fun showBlockScreen(type: String, item: String) {
        val intent = Intent(this, BlockedActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.putExtra("BLOCKED_TYPE", type)
        intent.putExtra("BLOCKED_ITEM", item)
        startActivity(intent)
    }

    override fun onInterrupt() {}
}