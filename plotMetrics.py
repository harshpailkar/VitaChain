import pandas as pd
import matplotlib.pyplot as plt

# Read Incremental Load Testing Metrics from CSV
incremental_load_metrics = pd.read_csv('incremental_load_metrics.csv')

# Set Palatino font and font size
palatino_font = {'fontname': 'Palatino Linotype', 'fontsize': 11}
palatino_fonts = {'fontname': 'Palatino Linotype', 'fontsize': 11, 'fontweight': 600}

# Plotting Incremental Load Testing Metrics
plt.figure(figsize=(8, 6))  # Adjust the figsize for smaller figures

plt.subplot(2, 2, 1)
plt.plot(incremental_load_metrics['NumTransactions'], incremental_load_metrics['IncrementalThroughput'])
plt.title('Incremental Throughput vs Num Transactions', **palatino_fonts)
plt.xlabel('Num Transactions', **palatino_font)
plt.ylabel('Incremental Throughput', **palatino_font)
plt.tick_params(axis='both', which='both', labelsize=10)
plt.xticks(fontname='Palatino', fontsize=10)
plt.yticks(fontname='Palatino', fontsize=10)

plt.subplot(2, 2, 2)
plt.plot(incremental_load_metrics['NumTransactions'], incremental_load_metrics['IncrementalLatency'])
plt.title('Incremental Latency vs Num Transactions', **palatino_fonts)
plt.xlabel('Num Transactions', **palatino_font)
plt.ylabel('Incremental Latency', **palatino_font)
plt.tick_params(axis='both', which='both', labelsize=10)
plt.xticks(fontname='Palatino', fontsize=10)
plt.yticks(fontname='Palatino', fontsize=10)

plt.subplot(2, 2, 3)
plt.plot(incremental_load_metrics['NumTransactions'], incremental_load_metrics['IncrementalGasUsed'])
plt.title('Incremental Gas Used vs Num Transactions', **palatino_fonts)
plt.xlabel('Num Transactions', **palatino_font)
plt.ylabel('Incremental Gas Used', **palatino_font)
plt.tick_params(axis='both', which='both', labelsize=10)
plt.xticks(fontname='Palatino', fontsize=10)
plt.yticks(fontname='Palatino', fontsize=10)

plt.tight_layout()
plt.savefig('incremental_load_metrics.svg')
plt.show()

# Read Multiple Concurrent Users Testing Metrics from CSV
concurrent_users_metrics = pd.read_csv('concurrent_users_metrics.csv')

# Plotting Multiple Concurrent Users Testing Metrics
plt.figure(figsize=(8, 6))  # Adjust the figsize for smaller figures

plt.subplot(2, 2, 1)
plt.plot(concurrent_users_metrics['UserCount'], concurrent_users_metrics['ConcurrentUsersThroughput'])
plt.title('Concurrent Users Throughput vs User Count', **palatino_fonts)
plt.xlabel('User Count', **palatino_font)
plt.ylabel('Concurrent Users Throughput', **palatino_font)
plt.tick_params(axis='both', which='both', labelsize=10)
plt.xticks(fontname='Palatino', fontsize=10)
plt.yticks(fontname='Palatino', fontsize=10)

plt.subplot(2, 2, 2)
plt.plot(concurrent_users_metrics['UserCount'], concurrent_users_metrics['ConcurrentUsersLatency'])
plt.title('Concurrent Users Latency vs User Count', **palatino_fonts)
plt.xlabel('User Count', **palatino_font)
plt.ylabel('Concurrent Users Latency', **palatino_font)
plt.tick_params(axis='both', which='both', labelsize=10)
plt.xticks(fontname='Palatino', fontsize=10)
plt.yticks(fontname='Palatino', fontsize=10)

plt.subplot(2, 2, 3)
plt.plot(concurrent_users_metrics['UserCount'], concurrent_users_metrics['ConcurrentUsersGasUsed'])
plt.title('Concurrent Users Gas Used vs User Count', **palatino_fonts)
plt.xlabel('User Count', **palatino_font)
plt.ylabel('Concurrent Users Gas Used', **palatino_font)
plt.tick_params(axis='both', which='both', labelsize=10)
plt.xticks(fontname='Palatino', fontsize=10)
plt.yticks(fontname='Palatino', fontsize=10)

plt.tight_layout()
plt.savefig('concurrent_users_metrics.svg')
plt.show()
